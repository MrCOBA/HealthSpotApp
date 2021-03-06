import CaBFoundation
import CaBFirebaseKit
import UIKit

// MARK: - Protocol

protocol LocalNotificationsScheduler: AnyObject {

    func reSchedule()

}

// MARK: - Implementation

final class LocalNotificationsSchedulerImpl: LocalNotificationsScheduler {

    // MARK: - Peivate Types

    private typealias Content = LocalNotificationAssistantImpl.Content

    // MARK: - Private Properties

    private let storage: RootSettingsStorage
    private let localNotificationsAssistant: LocalNotificationAssistant
    private let firebaseFirestoreMedicineCheckerController: FirebaseFirestoreMedicineCheckerController
    private let coreDataAssistant: CoreDataAssistant

    // MARK: - Init & Deinit

    init(storage: RootSettingsStorage,
         localNotificationsAssistant: LocalNotificationAssistant,
         firebaseFirestoreMedicineCheckerController: FirebaseFirestoreMedicineCheckerController,
         coreDataAssistant: CoreDataAssistant) {
        self.storage = storage
        self.localNotificationsAssistant = localNotificationsAssistant
        self.firebaseFirestoreMedicineCheckerController = firebaseFirestoreMedicineCheckerController
        self.coreDataAssistant = coreDataAssistant

        firebaseFirestoreMedicineCheckerController.add(observer: self)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleNotificationsAuthorizationSettings),
                                               name: UIApplication.didBecomeActiveNotification,
                                               object: nil)

        requestNotificationsAuthorizationStatus()
    }

    deinit {
        firebaseFirestoreMedicineCheckerController.remove(observer: self)
        NotificationCenter.default.removeObserver(self,
                                                  name: UIApplication.didBecomeActiveNotification,
                                                  object: nil)
    }

    // MARK: - Internal Methods

    func reSchedule() {
        localNotificationsAssistant.removeAllPendingNotifications()

        let periods: [MedicineItemPeriod] = coreDataAssistant.loadData("MedicineItemPeriod",
                                                                       predicate: nil,
                                                                       sortDescriptor: nil)?.compactMap { $0 as? MedicineItemPeriod} ?? []
        for period in periods {
            let content = createNotificationContentForPeriod(period)

            let frequency: Date.Frequency? = .init(rawValue: period.frequency ?? "")
            
            guard let endDate = period.endDate else {
                localNotificationsAssistant.scheduleNotification(notificationContent: content, frequency: frequency, from: period.startDate ?? Date())
                return
            }
            
            if endDate > Date() {
                localNotificationsAssistant.scheduleNotification(notificationContent: content, frequency: frequency, from: period.startDate ?? Date())
            }
        }
    }

    // MARK: - Private Methods

    private func createNotificationContentForPeriod(_ medicineItemPeriod: MedicineItemPeriod) -> Content {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let time = dateFormatter.string(from: medicineItemPeriod.startDate ?? Date())

        var body = "A reception is scheduled for \(time)!"
        if let hint = medicineItemPeriod.notificationHint, !hint.isEmpty {
            body += " \nHint: \(hint)"
        }
        return .init(identifier: medicineItemPeriod.id ?? "",
                     title: "Time to take your medicine!",
                     body: body,
                     category: "alert",
                     userInfo: [:])
    }

    @objc
    private func handleNotificationsAuthorizationSettings() {
        requestNotificationsAuthorizationStatus()
    }

    private func requestNotificationsAuthorizationStatus() {
        localNotificationsAssistant.notificationCenter.getNotificationSettings { [weak self] settings in
            self?.updateNotificationsAvailability(when: settings.authorizationStatus)
        }
    }

    private func updateNotificationsAvailability(when status: UNAuthorizationStatus) {
        switch status {
        case .authorized,
             .ephemeral,
             .provisional:
            storage.isNotificationEnabled = true

        case .notDetermined,
             .denied:
            storage.isNotificationEnabled = false

        @unknown default:
            logError(message: "Unknown notification authorization status: \(status)")
        }

        storage.isNotificationEnabled ? reSchedule() : localNotificationsAssistant.removeAllPendingNotifications()
    }

}

// MARK: - Protocol RootSettingsStorageObserver

extension LocalNotificationsSchedulerImpl: RootSettingsStorageObserver {

    func storage(_ storage: RootSettingsStorage,
                 didUpdateNotificationAvailablityTo newValue: Bool) {
        newValue
        ? reSchedule()
        : localNotificationsAssistant.removeAllPendingNotifications()
    }

}

// MARK: - Protocol FirebaseFirestoreMedicineCheckerDelegate

extension LocalNotificationsSchedulerImpl: FirebaseFirestoreMedicineCheckerDelegate {

    func didFinishStorageUpdate(with error: Error?) {
        guard error == nil else {
            return
        }

        reSchedule()
    }

    func didFinishUpload(with error: Error?) {
        /* Do Nothing */
    }

}
