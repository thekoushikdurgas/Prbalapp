import UIKit
import Flutter
import UserNotifications
import CoreLocation
import LocalAuthentication
import AVFoundation
import Photos

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    
    private let locationManager = CLLocationManager()
    private var methodChannel: FlutterMethodChannel?
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        // Configure notifications
        configureNotifications(application)
        
        // Setup Flutter method channel
        setupMethodChannel()
        
        // Configure location services
        configureLocationServices()
        
        // Configure app-specific settings
        configureAppSettings()
        
        // Generate Flutter plugins
        GeneratedPluginRegistrant.register(with: self)
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    // MARK: - Configuration Methods
    
    private func configureNotifications(_ application: UIApplication) {
        UNUserNotificationCenter.current().delegate = self
        
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound, .provisional, .criticalAlert]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { granted, error in
                if let error = error {
                    debugPrint("❌ Notification authorization error: \(error)")
                } else {
                    debugPrint("✅ Notification authorization granted: \(granted)")
                }
            }
        )
        
        // Create notification categories
        createNotificationCategories()
        
        // Register for remote notifications
        application.registerForRemoteNotifications()
    }
    
    private func createNotificationCategories() {
        // Booking notification category
        let viewBookingAction = UNNotificationAction(
            identifier: "VIEW_BOOKING",
            title: "View Details",
            options: [.foreground]
        )
        
        let bookingCategory = UNNotificationCategory(
            identifier: "BOOKING_CATEGORY",
            actions: [viewBookingAction],
            intentIdentifiers: [],
            options: []
        )
        
        // Message notification category
        let replyAction = UNTextInputNotificationAction(
            identifier: "REPLY_MESSAGE",
            title: "Reply",
            options: [.foreground],
            textInputButtonTitle: "Send",
            textInputPlaceholder: "Type your message..."
        )
        
        let messageCategory = UNNotificationCategory(
            identifier: "MESSAGE_CATEGORY",
            actions: [replyAction],
            intentIdentifiers: [],
            options: []
        )
        
        // Service request category
        let acceptAction = UNNotificationAction(
            identifier: "ACCEPT_REQUEST",
            title: "Accept",
            options: [.foreground]
        )
        
        let declineAction = UNNotificationAction(
            identifier: "DECLINE_REQUEST",
            title: "Decline",
            options: [.destructive]
        )
        
        let serviceCategory = UNNotificationCategory(
            identifier: "SERVICE_CATEGORY",
            actions: [acceptAction, declineAction],
            intentIdentifiers: [],
            options: []
        )
        
        UNUserNotificationCenter.current().setNotificationCategories([
            bookingCategory, messageCategory, serviceCategory
        ])
    }
    
    private func setupMethodChannel() {
        guard let controller = window?.rootViewController as? FlutterViewController else {
            return
        }
        
        methodChannel = FlutterMethodChannel(
            name: "com.durgas.prbal/native",
            binaryMessenger: controller.binaryMessenger
        )
        
        methodChannel?.setMethodCallHandler { [weak self] (call, result) in
            self?.handleMethodCall(call, result: result)
        }
    }
    
    private func configureLocationServices() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    private func configureAppSettings() {
        // Configure app-wide settings
        if #available(iOS 13.0, *) {
            // Configure for dark mode support
            UIApplication.shared.windows.forEach { window in
                window.overrideUserInterfaceStyle = .unspecified
            }
        }
        
        // Configure navigation bar appearance
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor.systemBackground
            appearance.titleTextAttributes = [.foregroundColor: UIColor.label]
            
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
        }
    }
    
    // MARK: - Method Channel Handling
    
    private func handleMethodCall(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "getDeviceInfo":
            result(getDeviceInfo())
        case "getBatteryLevel":
            result(getBatteryLevel())
        case "requestPermissions":
            requestPermissions(call.arguments as? [String] ?? [], result: result)
        case "openSettings":
            openAppSettings()
            result(true)
        case "shareContent":
            shareContent(call.arguments as? [String: Any], result: result)
        case "openUrl":
            if let args = call.arguments as? [String: Any],
               let url = args["url"] as? String {
                openUrl(url)
                result(true)
            } else {
                result(FlutterError(code: "INVALID_URL", message: "URL is required", details: nil))
            }
        case "authenticateWithBiometrics":
            authenticateWithBiometrics(result: result)
        case "setAppBadge":
            if let args = call.arguments as? [String: Any],
               let count = args["count"] as? Int {
                setAppBadge(count)
                result(true)
            } else {
                result(FlutterError(code: "INVALID_COUNT", message: "Count is required", details: nil))
            }
        case "requestLocationPermission":
            requestLocationPermission(result: result)
        case "getCurrentLocation":
            getCurrentLocation(result: result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    // MARK: - Native Method Implementations
    
    private func getDeviceInfo() -> [String: Any] {
        let device = UIDevice.current
        return [
            "systemName": device.systemName,
            "systemVersion": device.systemVersion,
            "model": device.model,
            "name": device.name,
            "identifierForVendor": device.identifierForVendor?.uuidString ?? "",
            "isPhysicalDevice": isPhysicalDevice(),
            "screenScale": UIScreen.main.scale,
            "screenBounds": [
                "width": UIScreen.main.bounds.width,
                "height": UIScreen.main.bounds.height
            ]
        ]
    }
    
    private func isPhysicalDevice() -> Bool {
        #if targetEnvironment(simulator)
        return false
        #else
        return true
        #endif
    }
    
    private func getBatteryLevel() -> Int {
        UIDevice.current.isBatteryMonitoringEnabled = true
        let batteryLevel = UIDevice.current.batteryLevel
        UIDevice.current.isBatteryMonitoringEnabled = false
        
        if batteryLevel < 0 {
            return -1 // Battery level unknown
        }
        return Int(batteryLevel * 100)
    }
    
    private func requestPermissions(_ permissions: [String], result: @escaping FlutterResult) {
        // Handle iOS permission requests
        for permission in permissions {
            switch permission {
            case "camera":
                requestCameraPermission()
            case "photos":
                requestPhotoPermission()
            case "location":
                requestLocationPermission(result: nil)
            case "notifications":
                // Already handled in configureNotifications
                break
            default:
                break
            }
        }
        result(true)
    }
    
    private func requestCameraPermission() {
        AVCaptureDevice.requestAccess(for: .video) { granted in
            debugPrint("Camera permission granted: \(granted)")
        }
    }
    
    private func requestPhotoPermission() {
        PHPhotoLibrary.requestAuthorization { status in
            debugPrint("Photo permission status: \(status.rawValue)")
        }
    }
    
    private func openAppSettings() {
        if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(settingsUrl)
        }
    }
    
    private func shareContent(_ arguments: [String: Any]?, result: @escaping FlutterResult) {
        guard let args = arguments,
              let title = args["title"] as? String,
              let text = args["text"] as? String else {
            result(FlutterError(code: "INVALID_ARGS", message: "Title and text are required", details: nil))
            return
        }
        
        var items: [Any] = [text]
        
        if let url = args["url"] as? String, let shareUrl = URL(string: url) {
            items.append(shareUrl)
        }
        
        DispatchQueue.main.async {
            let activityController = UIActivityViewController(activityItems: items, applicationActivities: nil)
            
            if let rootViewController = self.window?.rootViewController {
                // Handle iPad presentation
                if let popover = activityController.popoverPresentationController {
                    popover.sourceView = rootViewController.view
                    popover.sourceRect = CGRect(x: rootViewController.view.bounds.midX,
                                              y: rootViewController.view.bounds.midY,
                                              width: 0, height: 0)
                    popover.permittedArrowDirections = []
                }
                
                rootViewController.present(activityController, animated: true) {
                    result(true)
                }
            }
        }
    }
    
    private func openUrl(_ urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
    
    private func authenticateWithBiometrics(result: @escaping FlutterResult) {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.biometryAny, error: &error) {
            let reason = "Authenticate to access your Prbal account securely"
            
            context.evaluatePolicy(.biometryAny, localizedReason: reason) { success, authError in
                DispatchQueue.main.async {
                    if success {
                        result(true)
                    } else {
                        let errorMessage = authError?.localizedDescription ?? "Authentication failed"
                        result(FlutterError(code: "AUTH_ERROR", message: errorMessage, details: nil))
                    }
                }
            }
        } else {
            let errorMessage = error?.localizedDescription ?? "Biometric authentication not available"
            result(FlutterError(code: "BIOMETRY_UNAVAILABLE", message: errorMessage, details: nil))
        }
    }
    
    private func setAppBadge(_ count: Int) {
        DispatchQueue.main.async {
            UIApplication.shared.applicationIconBadgeNumber = count
        }
    }
    
    private func requestLocationPermission(result: FlutterResult?) {
        locationManager.requestWhenInUseAuthorization()
        result?(true)
    }
    
    private func getCurrentLocation(result: @escaping FlutterResult) {
        guard CLLocationManager.locationServicesEnabled() else {
            result(FlutterError(code: "LOCATION_DISABLED", message: "Location services disabled", details: nil))
            return
        }
        
        locationManager.requestLocation()
        // Note: Actual location will be returned via delegate methods
        // This is a simplified implementation
    }
    
    // MARK: - Deep Link Handling
    
    override func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey : Any] = [:]
    ) -> Bool {
        // Handle custom URL schemes
        if url.scheme == "prbal" {
            handleDeepLink(url)
            return true
        }
        
        return super.application(app, open: url, options: options)
    }
    
    override func application(
        _ application: UIApplication,
        continue userActivity: NSUserActivity,
        restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void
    ) -> Bool {
        // Handle universal links
        if let url = userActivity.webpageURL {
            handleDeepLink(url)
            return true
        }
        
        return super.application(application, continue: userActivity, restorationHandler: restorationHandler)
    }
    
    private func handleDeepLink(_ url: URL) {
        let deepLinkData: [String: Any?] = [
            "scheme": url.scheme,
            "host": url.host,
            "path": url.path,
            "query": url.query,
            "fragment": url.fragment
        ]
        
        methodChannel?.invokeMethod("onDeepLink", arguments: deepLinkData)
    }
    
    // MARK: - Remote Notifications
    
    override func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        super.application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
        
        // Handle device token for custom push notification service
        let tokenString = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        debugPrint("✅ Device token: \(tokenString)")
        
        // Send token to Flutter
        let tokenData = ["token": tokenString]
        methodChannel?.invokeMethod("onDeviceTokenReceived", arguments: tokenData)
    }
    
    override func application(
        _ application: UIApplication,
        didFailToRegisterForRemoteNotificationsWithError error: Error
    ) {
        debugPrint("❌ Failed to register for remote notifications: \(error)")
        super.application(application, didFailToRegisterForRemoteNotificationsWithError: error)
    }
}

// MARK: - User Notifications Delegate

extension AppDelegate: UNUserNotificationCenterDelegate {
    // Handle notification when app is in foreground
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.banner, .sound, .badge])
    }
    
    // Handle notification tap
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        let actionIdentifier = response.actionIdentifier
        let userInfo = response.notification.request.content.userInfo
        
        var actionData: [String: Any] = [
            "action": actionIdentifier,
            "userInfo": userInfo
        ]
        
        // Handle text input responses
        if let textResponse = response as? UNTextInputNotificationResponse {
            actionData["text"] = textResponse.userText
        }
        
        methodChannel?.invokeMethod("onNotificationAction", arguments: actionData)
        
        completionHandler()
    }
}

// MARK: - Location Manager Delegate

extension AppDelegate: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        let locationData: [String: Any] = [
            "latitude": location.coordinate.latitude,
            "longitude": location.coordinate.longitude,
            "accuracy": location.horizontalAccuracy,
            "altitude": location.altitude,
            "speed": location.speed,
            "timestamp": location.timestamp.timeIntervalSince1970
        ]
        
        methodChannel?.invokeMethod("onLocationUpdate", arguments: locationData)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        debugPrint("❌ Location error: \(error)")
        
        let errorData: [String: Any] = [
            "code": (error as NSError).code,
            "message": error.localizedDescription
        ]
        
        methodChannel?.invokeMethod("onLocationError", arguments: errorData)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        let statusString: String
        
        switch status {
        case .notDetermined:
            statusString = "notDetermined"
        case .restricted:
            statusString = "restricted"
        case .denied:
            statusString = "denied"
        case .authorizedAlways:
            statusString = "authorizedAlways"
        case .authorizedWhenInUse:
            statusString = "authorizedWhenInUse"
        @unknown default:
            statusString = "unknown"
        }
        
        let authData = ["status": statusString]
        methodChannel?.invokeMethod("onLocationAuthorizationChanged", arguments: authData)
    }
}
