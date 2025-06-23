import UserNotifications
import UIKit

@available(iOS 10.0, *)
class PrbalNotificationService: UNNotificationServiceExtension {
    
    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?
    
    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        
        if let bestAttemptContent = bestAttemptContent {
            // Modify the notification content here
            
            // Add rich media if available
            if let imageURLString = bestAttemptContent.userInfo["image_url"] as? String,
               let imageURL = URL(string: imageURLString) {
                downloadImage(from: imageURL) { [weak self] image in
                    if let image = image {
                        self?.addImageAttachment(image: image, to: bestAttemptContent)
                    }
                    contentHandler(bestAttemptContent)
                }
            } else {
                // Process notification without image
                processNotification(content: bestAttemptContent)
                contentHandler(bestAttemptContent)
            }
        }
    }
    
    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content,
        // otherwise the original push payload will be used.
        if let contentHandler = contentHandler, let bestAttemptContent = bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }
    
    private func processNotification(content: UNMutableNotificationContent) {
        // Customize notification based on type
        if let notificationType = content.userInfo["type"] as? String {
            switch notificationType {
            case "booking_update":
                content.title = "🔔 " + content.title
                content.categoryIdentifier = "BOOKING_CATEGORY"
                content.sound = UNNotificationSound(named: UNNotificationSoundName("booking_sound.wav"))
                
            case "new_message":
                content.title = "💬 " + content.title
                content.categoryIdentifier = "MESSAGE_CATEGORY"
                content.sound = UNNotificationSound(named: UNNotificationSoundName("message_sound.wav"))
                
            case "service_request":
                content.title = "🛠️ " + content.title
                content.categoryIdentifier = "SERVICE_CATEGORY"
                content.sound = UNNotificationSound.default
                
            case "payment_update":
                content.title = "💳 " + content.title
                content.sound = UNNotificationSound(named: UNNotificationSoundName("payment_sound.wav"))
                
            case "promotion":
                content.title = "🎉 " + content.title
                content.sound = UNNotificationSound(named: UNNotificationSoundName("promotion_sound.wav"))
                
            default:
                content.title = "📱 " + content.title
                content.sound = UNNotificationSound.default
            }
        }
        
        // Add badge count
        if let badgeCount = content.userInfo["badge"] as? NSNumber {
            content.badge = badgeCount
        }
        
        // Add thread identifier for grouping
        if let threadId = content.userInfo["thread_id"] as? String {
            content.threadIdentifier = threadId
        }
        
        // Add custom user info for analytics
        var updatedUserInfo = content.userInfo
        updatedUserInfo["processed_at"] = Date().timeIntervalSince1970
        updatedUserInfo["app_version"] = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        content.userInfo = updatedUserInfo
    }
    
    private func downloadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            
            let image = UIImage(data: data)
            completion(image)
        }.resume()
    }
    
    private func addImageAttachment(image: UIImage, to content: UNMutableNotificationContent) {
        // Save image to temporary directory
        let tempDirectory = NSTemporaryDirectory()
        let fileName = UUID().uuidString + ".png"
        let tempURL = URL(fileURLWithPath: tempDirectory).appendingPathComponent(fileName)
        
        guard let imageData = image.pngData() else { return }
        
        do {
            try imageData.write(to: tempURL)
            let attachment = try UNNotificationAttachment(identifier: "image", url: tempURL, options: nil)
            content.attachments = [attachment]
        } catch {
            debugPrint("Error creating notification attachment: \(error)")
        }
    }
} 