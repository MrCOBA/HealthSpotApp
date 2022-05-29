import CaBFoundation
import CaBFirebaseKit

// MARK: - Protocol

protocol LocalNotificationsScheduler: AnyObject {

    func reSchedule()

}

// MARK: - Implementation

final class LocalNotificationsSchedulerImpl: LocalNotificationsScheduler {

    // MARK: - Peivate Types

    private typealias Content = LocalNotificationAssistantImpl.Content

    // MARK: - Private Properties

    private let localNotificationsAssistant: LocalNotificationAssistant
    private let firebaseFirestoreMedicineCheckerController: FirebaseFirestoreMedicineCheckerController
    private let coreDataAssistant: CoreDataAssistant

    // MARK: - Init & Deinit

    init(localNotificationsAssistant: LocalNotificationAssistant,
         firebaseFirestoreMedicineCheckerController: FirebaseFirestoreMedicineCheckerController,
         coreDataAssistant: CoreDataAssistant) {
        self.localNotificationsAssistant = localNotificationsAssistant
        self.firebaseFirestoreMedicineCheckerController = firebaseFirestoreMedicineCheckerController
        self.coreDataAssistant = coreDataAssistant

        firebaseFirestoreMedicineCheckerController.addObserver(self)
    }

    deinit {
        firebaseFirestoreMedicineCheckerController.removeObserver(self)
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
            localNotificationsAssistant.scheduleNotification(notificationContent: content, frequency: frequency, from: period.startDate ?? Date())
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
