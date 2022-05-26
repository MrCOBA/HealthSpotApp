import UserNotifications

// MARK: - Protocol

public protocol LocalNotificationAssistant: AnyObject {

    func push(notificationContent: LocalNotificationAssistantImpl.Content)

}

// MARK: - Implementation

public final class LocalNotificationAssistantImpl: LocalNotificationAssistant {

    // MARK: - Public Types

    public struct Content {
        let title: String
        let body: String
        let category: String
        let userInfo: [String: Any]

        public init(title: String,
                    body: String,
                    category: String,
                    userInfo: [String: Any]) {
            self.title = title
            self.body = body
            self.category = category
            self.userInfo = userInfo
        }
    }

    // MARK: - Private Properties

    private let storage: RootSettingsStorage

    // MARK: - Init

    public init(storage: RootSettingsStorage) {
        self.storage = storage

        if !storage.isNotificationPermissionsRequested {
            requestPermission()
        }

    }

    // MARK: - Public Methods

    public func push(notificationContent: Content) {
        let center = UNUserNotificationCenter.current()

        let content = UNMutableNotificationContent()
        content.title = notificationContent.title
        content.body = notificationContent.body
        content.categoryIdentifier = notificationContent.category
        content.userInfo = notificationContent.userInfo

        content.sound = UNNotificationSound.default

        var dateComponents = DateComponents()
        dateComponents.hour = 10
        dateComponents.minute = 30
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)

        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
    }

    // MARK: - Private Methods

    private func requestPermission() {
        let center = UNUserNotificationCenter.current()

        center.requestAuthorization(options: [.alert, .badge, .sound]) { [weak self] (granted, error) in
            if granted {
                logInfo(message: "Notification permissions granted")
            } else {
                logInfo(message: "Notification permissions not granted")
            }

            self?.storage.isNotificationPermissionsRequested = true
        }
    }

}
