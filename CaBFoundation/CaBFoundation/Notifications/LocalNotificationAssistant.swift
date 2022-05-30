import UserNotifications
import UIKit

// MARK: - Protocol

public protocol LocalNotificationAssistant: AnyObject {

    var notificationCenter: UNUserNotificationCenter { get }

    func changeAvailability(to isNotificationsAvailable: Bool)
    func push(notificationContent: LocalNotificationAssistantImpl.Content, with customTrigger: UNNotificationTrigger?)
    func scheduleNotification(notificationContent: LocalNotificationAssistantImpl.Content, frequency: Date.Frequency?, from startDate: Date)
    func removePendingNotification(with identifier: String)
    func removeAllPendingNotifications()

}

// MARK: - Implementation

public final class LocalNotificationAssistantImpl: LocalNotificationAssistant {

    // MARK: - Public Types

    public struct Content {
        let identifier: String
        let title: String
        let body: String
        let category: String
        let userInfo: [String: Any]

        public init(identifier: String,
                    title: String,
                    body: String,
                    category: String,
                    userInfo: [String: Any]) {
            self.identifier = identifier
            self.title = title
            self.body = body
            self.category = category
            self.userInfo = userInfo
        }
    }

    // MARK: - Public Properties

    public let notificationCenter: UNUserNotificationCenter

    // MARK: - Private Properties

    private let storage: RootSettingsStorage

    // MARK: - Init

    public init(storage: RootSettingsStorage) {
        self.storage = storage
        self.notificationCenter = UNUserNotificationCenter.current()

        if !storage.isNotificationPermissionsRequested {
            requestPermission()
        }
    }

    // MARK: - Public Methods

    public func changeAvailability(to isNotificationsEnabled: Bool) {
        notificationCenter.getNotificationSettings { [weak self] settings in
            switch settings.authorizationStatus {
            case .authorized,
                 .ephemeral,
                 .provisional:
                self?.storage.isNotificationEnabled = isNotificationsEnabled

            case .denied,
                 .notDetermined:
                guard let url = URL(string: UIApplication.openSettingsURLString) else {
                    return
                }
                DispatchQueue.main.async {
                    UIApplication.shared.open(url)
                }

            @unknown default:
                logError(message: "Unknown notification authorization status: \(settings.authorizationStatus)")
            }
        }
    }

    public func push(notificationContent: Content, with customTrigger: UNNotificationTrigger? = nil) {
        guard storage.isNotificationEnabled else {
            return
        }

        let content = UNMutableNotificationContent()
        content.title = notificationContent.title
        content.body = notificationContent.body
        content.categoryIdentifier = notificationContent.category
        content.userInfo = notificationContent.userInfo

        content.sound = UNNotificationSound.default

        var dateComponents = DateComponents()
        dateComponents.hour = 10
        dateComponents.minute = 30


        let trigger = (customTrigger == nil) ? UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false) : customTrigger

        let request = UNNotificationRequest(identifier: notificationContent.identifier, content: content, trigger: trigger)
        notificationCenter.add(request)
    }

    public func scheduleNotification(notificationContent: Content, frequency: Date.Frequency?, from startDate: Date) {
        let components: Set<Calendar.Component> = (frequency == nil)
        ? Set([.day, .hour, .minute])
        : Set(frequency!.triggerDateComponents)

        let triggerFrequency = Calendar.current.dateComponents(components, from: startDate)

        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerFrequency, repeats: (frequency != nil))

        push(notificationContent: notificationContent, with: trigger)
    }

    public func removePendingNotification(with identifier: String) {
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [identifier])
    }

    public func removeAllPendingNotifications() {
        notificationCenter.removeAllPendingNotificationRequests()
    }

    // MARK: - Private Methods

    private func requestPermission() {
        notificationCenter.requestAuthorization(options: [.alert, .badge, .sound]) { [weak self] (granted, error) in
            if granted {
                logInfo(message: "Notification permissions granted")
                self?.storage.isNotificationEnabled = true
            } else {
                logInfo(message: "Notification permissions not granted")
                self?.storage.isNotificationEnabled = false
            }

            self?.storage.isNotificationPermissionsRequested = true
        }
    }

}

extension Date.Frequency {

    var triggerDateComponents: [Calendar.Component] {
        switch self {
        case .daily:
            return [.minute, .hour]

        case .weekly:
            return Self.daily.triggerDateComponents + [.weekday]

        case .monthly:
            return Self.daily.triggerDateComponents + [.day]

        case .yearly:
            return Self.monthly.triggerDateComponents + [.month]
        }
    }

}
