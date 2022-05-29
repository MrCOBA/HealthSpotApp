import CaBRiblets
import CaBFoundation

final class HealthActivityStatisticsTrackerInteractorImpl: BaseInteractor {

    private let watchKitConnection: WatchKitConnection
    private let dataTrackingAssistant: HealthDataTracking

    private let statisticsStorage: HealthActivityStatisticsStorage
    private let localNotificationsAssistant: LocalNotificationAssistant

    init(connection: WatchKitConnection,
         dataTracking: HealthDataTracking,
         statisticsStorage: HealthActivityStatisticsStorage,
         localNotificationsAssistant: LocalNotificationAssistant) {
        self.watchKitConnection = connection
        self.dataTrackingAssistant = dataTracking
        self.statisticsStorage = statisticsStorage
        self.localNotificationsAssistant = localNotificationsAssistant
    }

    override func start() {
        super.start()

        watchKitConnection.delegate = self
        statisticsStorage.add(observer: self)

        dataTrackingAssistant.authorizeHealthKit()
        dataTrackingAssistant.startObserveHeartRateSamples()
        dataTrackingAssistant.startObserveStepsCountSamples()
        dataTrackingAssistant.startObserveActiveBurntEnergySamples()
    }

    override func stop() {
        statisticsStorage.remove(observer: self)
        dataTrackingAssistant.stopObserveHeartRateSamples()
        dataTrackingAssistant.stopObserveStepsCountSamples()
        dataTrackingAssistant.stopObserveActiveBurnedEnergySamples()
        
        super.stop()
    }

}

extension HealthActivityStatisticsTrackerInteractorImpl: WatchKitConnectionDelegate {

    func didFinishedActivateSession() {
        watchKitConnection.sendMessage(message: ["username" : "mrcoba" as AnyObject], replyHandler: nil, errorHandler: nil)
    }

}

extension HealthActivityStatisticsTrackerInteractorImpl: HealthActivityStatisticsStorageObserver {

    func storage(_ storage: HealthActivityStatisticsStorage, didUpdateHeartRateTo newValue: Double) {
        localNotificationsAssistant.push(notificationContent: .init(title: "Current heart rate",
                                                                    body: "Heart Rate = \(newValue)",
                                                                    category: "alarm",
                                                                    userInfo: ["customData": "fizzbuzz"]))
    }
    
}
