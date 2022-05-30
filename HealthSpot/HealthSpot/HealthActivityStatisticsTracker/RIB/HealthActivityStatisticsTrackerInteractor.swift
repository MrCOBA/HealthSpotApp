import CaBRiblets
import CaBFoundation

final class HealthActivityStatisticsTrackerInteractorImpl: BaseInteractor {

    private enum Achievement {
        case startGoal
        case halfGoal
        case fullGoal
    }

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

        watchKitConnection.sendMessage(message: ["command" : true as AnyObject], replyHandler: nil, errorHandler: nil)
    }

    override func stop() {
        statisticsStorage.remove(observer: self)
        dataTrackingAssistant.stopObserveHeartRateSamples()
        dataTrackingAssistant.stopObserveStepsCountSamples()
        dataTrackingAssistant.stopObserveActiveBurnedEnergySamples()

        watchKitConnection.sendMessage(message: ["command" : false as AnyObject], replyHandler: nil, errorHandler: nil)
        
        super.stop()
    }

    private func pushStepsCountAchievement(_ achievement: Achievement) {

    }

    private func pushBurnedEnergyAchievement(_ achievement: Achievement) {

    }

}

extension HealthActivityStatisticsTrackerInteractorImpl: WatchKitConnectionDelegate {

    func didFinishedActivateSession() { /* Do Nothing */ }

}

extension HealthActivityStatisticsTrackerInteractorImpl: HealthActivityStatisticsStorageObserver {

    func storage(_ storage: HealthActivityStatisticsStorage, didUpdateHeartRateTo newValue: Double) {
        // TODO: Add heart rate analytics
    }

    func storage(_ storage: HealthActivityStatisticsStorage, didUpdateStepsCountTo newValue: Double) {
        
    }

    func storage(_ storage: HealthActivityStatisticsStorage, didUpdateBurnedCalloriesTo newValue: Double) {

    }

}
