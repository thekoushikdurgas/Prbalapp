import LocalAuthentication
import Security
import CryptoKit
import UIKit

class PrbalSecurityManager {
    
    static let shared = PrbalSecurityManager()
    
    private init() {}
    
    // MARK: - Biometric Authentication
    
    func isBiometricAuthenticationAvailable() -> Bool {
        let context = LAContext()
        var error: NSError?
        return context.canEvaluatePolicy(.biometryAny, error: &error)
    }
    
    func getBiometricType() -> LABiometryType {
        let context = LAContext()
        _ = context.canEvaluatePolicy(.biometryAny, error: nil)
        return context.biometryType
    }
    
    func authenticateWithBiometrics(reason: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        let context = LAContext()
        var error: NSError?
        
        guard context.canEvaluatePolicy(.biometryAny, error: &error) else {
            completion(.failure(SecurityError.biometricNotAvailable))
            return
        }
        
        context.evaluatePolicy(.biometryAny, localizedReason: reason) { success, authError in
            DispatchQueue.main.async {
                if success {
                    completion(.success(true))
                } else if let error = authError {
                    completion(.failure(error))
                } else {
                    completion(.failure(SecurityError.authenticationFailed))
                }
            }
        }
    }
    
    func authenticateWithPasscode(reason: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        let context = LAContext()
        
        context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { success, authError in
            DispatchQueue.main.async {
                if success {
                    completion(.success(true))
                } else if let error = authError {
                    completion(.failure(error))
                } else {
                    completion(.failure(SecurityError.authenticationFailed))
                }
            }
        }
    }
    
    // MARK: - Secure Storage (Keychain)
    
    func saveToKeychain(key: String, value: String) -> Bool {
        guard let data = value.data(using: .utf8) else { return false }
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: data,
            kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlockedThisDeviceOnly
        ]
        
        // Delete existing item
        SecItemDelete(query as CFDictionary)
        
        // Add new item
        let status = SecItemAdd(query as CFDictionary, nil)
        return status == errSecSuccess
    }
    
    func loadFromKeychain(key: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        guard status == errSecSuccess,
              let data = result as? Data,
              let string = String(data: data, encoding: .utf8) else {
            return nil
        }
        
        return string
    }
    
    func deleteFromKeychain(key: String) -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        return status == errSecSuccess
    }
    
    func saveSecureData(key: String, value: Data, requiresBiometric: Bool = false) -> Bool {
        var accessibility = kSecAttrAccessibleWhenUnlockedThisDeviceOnly
        
        if requiresBiometric && isBiometricAuthenticationAvailable() {
            accessibility = kSecAttrAccessibleBiometryAny
        }
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: value,
            kSecAttrAccessible as String: accessibility
        ]
        
        // Delete existing item
        SecItemDelete(query as CFDictionary)
        
        // Add new item
        let status = SecItemAdd(query as CFDictionary, nil)
        return status == errSecSuccess
    }
    
    func loadSecureData(key: String) -> Data? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        guard status == errSecSuccess, let data = result as? Data else {
            return nil
        }
        
        return data
    }
    
    // MARK: - Encryption/Decryption
    
    func encryptData(_ data: Data, key: SymmetricKey) throws -> Data {
        if #available(iOS 13.0, *) {
            let sealedBox = try AES.GCM.seal(data, using: key)
            return sealedBox.combined!
        } else {
            // Fallback for older iOS versions
            throw SecurityError.encryptionNotSupported
        }
    }
    
    func decryptData(_ encryptedData: Data, key: SymmetricKey) throws -> Data {
        if #available(iOS 13.0, *) {
            let sealedBox = try AES.GCM.SealedBox(combined: encryptedData)
            return try AES.GCM.open(sealedBox, using: key)
        } else {
            // Fallback for older iOS versions
            throw SecurityError.decryptionNotSupported
        }
    }
    
    func generateEncryptionKey() -> SymmetricKey {
        if #available(iOS 13.0, *) {
            return SymmetricKey(size: .bits256)
        } else {
            // Fallback - this is a simplified implementation
            fatalError("Encryption not supported on iOS < 13.0")
        }
    }
    
    // MARK: - App Security
    
    func isJailbroken() -> Bool {
        // Check for common jailbreak indicators
        let paths = [
            "/Applications/Cydia.app",
            "/Library/MobileSubstrate/MobileSubstrate.dylib",
            "/bin/bash",
            "/usr/sbin/sshd",
            "/etc/apt",
            "/private/var/lib/apt/"
        ]
        
        for path in paths {
            if FileManager.default.fileExists(atPath: path) {
                return true
            }
        }
        
        // Try to write to a restricted directory
        do {
            let testString = "test"
            try testString.write(toFile: "/private/jailbreak_test.txt", atomically: true, encoding: .utf8)
            return true // If successful, device is likely jailbroken
        } catch {
            // Normal behavior on non-jailbroken devices
        }
        
        return false
    }
    
    func isDebuggingDetected() -> Bool {
        var info = kinfo_proc()
        var mib: [Int32] = [CTL_KERN, KERN_PROC, KERN_PROC_PID, getpid()]
        var size = MemoryLayout<kinfo_proc>.stride
        
        let result = sysctl(&mib, u_int(mib.count), &info, &size, nil, 0)
        
        if result != 0 {
            return false
        }
        
        return (info.kp_proc.p_flag & P_TRACED) != 0
    }
    
    func preventScreenCapture() {
        guard let window = UIApplication.shared.windows.first else { return }
        
        let field = UITextField()
        field.isSecureTextEntry = true
        window.addSubview(field)
        field.isHidden = true
        field.layer.sublayers?.first?.addSublayer(window.layer)
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: window.frame.width, height: window.frame.height))
        field.leftViewMode = .always
    }
    
    func enableScreenshotDetection() {
        NotificationCenter.default.addObserver(
            forName: UIApplication.userDidTakeScreenshotNotification,
            object: nil,
            queue: .main
        ) { _ in
            self.handleScreenshotDetected()
        }
    }
    
    private func handleScreenshotDetected() {
        // Log security event
        debugPrint("🚨 Screenshot detected!")
        
        // You could implement additional security measures here:
        // - Log out the user
        // - Send analytics event
        // - Show warning dialog
        // - Blur sensitive content
        
        NotificationCenter.default.post(name: .screenshotDetected, object: nil)
    }
    
    // MARK: - Certificate Pinning
    
    func validateCertificate(challenge: URLAuthenticationChallenge, pinnedCertificates: [Data]) -> Bool {
        guard let serverTrust = challenge.protectionSpace.serverTrust else {
            return false
        }
        
        let serverCertificate = SecTrustGetCertificateAtIndex(serverTrust, 0)
        guard let serverCertData = serverCertificate.flatMap({ SecCertificateCopyData($0) }) else {
            return false
        }
        
        let serverCertificateData = Data(bytes: CFDataGetBytePtr(serverCertData), count: CFDataGetLength(serverCertData))
        
        return pinnedCertificates.contains(serverCertificateData)
    }
    
    // MARK: - Secure Communication
    
    func hashData(_ data: Data) -> Data {
        if #available(iOS 13.0, *) {
            return Data(SHA256.hash(data: data))
        } else {
            // Fallback for older iOS versions
            var hash = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
            data.withUnsafeBytes {
                _ = CC_SHA256($0.baseAddress, CC_LONG(data.count), &hash)
            }
            return Data(hash)
        }
    }
    
    func generateRandomData(length: Int) -> Data {
        var data = Data(count: length)
        let result = data.withUnsafeMutableBytes {
            SecRandomCopyBytes(kSecRandomDefault, length, $0.baseAddress!)
        }
        
        if result == errSecSuccess {
            return data
        } else {
            // Fallback to less secure random generation
            return Data((0..<length).map { _ in UInt8.random(in: 0...255) })
        }
    }
}

// MARK: - Security Errors

enum SecurityError: Error, LocalizedError {
    case biometricNotAvailable
    case authenticationFailed
    case encryptionNotSupported
    case decryptionNotSupported
    case keychainError
    case jailbrokenDevice
    case debuggingDetected
    
    var errorDescription: String? {
        switch self {
        case .biometricNotAvailable:
            return "Biometric authentication is not available"
        case .authenticationFailed:
            return "Authentication failed"
        case .encryptionNotSupported:
            return "Encryption is not supported on this device"
        case .decryptionNotSupported:
            return "Decryption is not supported on this device"
        case .keychainError:
            return "Keychain operation failed"
        case .jailbrokenDevice:
            return "Security compromised: Jailbroken device detected"
        case .debuggingDetected:
            return "Security compromised: Debugging detected"
        }
    }
}

// MARK: - Notification Names

extension Notification.Name {
    static let screenshotDetected = Notification.Name("screenshotDetected")
    static let securityThreatDetected = Notification.Name("securityThreatDetected")
}

// MARK: - C Functions (for debugging detection)

import Darwin

private let P_TRACED = 0x00000800 