import CaBRiblets
import CaBFoundation

final class HealthActivityStatisticsTrackerInteractorImpl: BaseInteractor {

    typealias Achievement = HealthActivityAchievementsNotificationsFactory.Achievement
    
    private let watchKitConnection: WatchKitConnection
    private let dataTrackingAssistant: HealthDataTracking

    private let statisticsStorage: HealthActivityStatisticsStorage
    private let achievementsStorage: HealthActivityAchievementsStorage
    private let localNotificationsAssistant: LocalNotificationAssistant

    private let notificationsFactory: HealthActivityAchievementsNotificationsFactory

    init(connection: WatchKitConnection,
         dataTracking: HealthDataTracking,
         statisticsStorage: HealthActivityStatisticsStorage,
         achievementsStorage: HealthActivityAchievementsStorage,
         localNotificationsAssistant: LocalNotificationAssistant) {
        self.watchKitConnection = connection
        self.dataTrackingAssistant = dataTracking
        self.statisticsStorage = statisticsStorage
        self.achievementsStorage = achievementsStorage
        self.localNotificationsAssistant = localNotificationsAssistant

        self.notificationsFactory = HealthActivityAchievementsNotificationsFactory()
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
        let content = notificationsFactory.makeStepsNotification(for: achievement)
        localNotificationsAssistant.push(notificationContent: content, with: nil)
    }

    private func pushBurnedEnergyAchievement(_ achievement: Achievement) {
        let content = notificationsFactory.makeCalloriesNotification(for: achievement)
        localNotificationsAssistant.push(notificationContent: content, with: nil)
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
        if !achievementsStorage.currentDate.compare(with: Date()) {
            achievementsStorage.resetStorage()
            achievementsStorage.currentDate = Date()
        }

        if !achievementsStorage.isStartStepsAchievementReceived {
            pushStepsCountAchievement(.startGoal)
            achievementsStorage.isStartStepsAchievementReceived = true
        }

        if ((storage.stepsGoal / newValue) <= 2.0) && !achievementsStorage.isHalfStepsAchievementReceived {
            pushStepsCountAchievement(.halfGoal)
            achievementsStorage.isHalfStepsAchievementReceived = true
        }

        if ((storage.stepsGoal / newValue) <= 1.0) && !achievementsStorage.isFullStepsAchievementReceived {
            pushStepsCountAchievement(.fullGoal)
            achievementsStorage.isFullStepsAchievementReceived = true
        }
    }

    func storage(_ storage: HealthActivityStatisticsStorage, didUpdateBurnedCalloriesTo newValue: Double) {
        if !achievementsStorage.currentDate.compare(with: Date()) {
            achievementsStorage.resetStorage()
            achievementsStorage.currentDate = Date()
        }

        if !achievementsStorage.isStartCalloriesAchievementReceived {
            pushBurnedEnergyAchievement(.startGoal)
            achievementsStorage.isStartCalloriesAchievementReceived = true
        }

        if ((storage.calloriesGoal / newValue) <= 2.0) && !achievementsStorage.isHalfCalloriesAchievementReceived {
            pushBurnedEnergyAchievement(.halfGoal)
            achievementsStorage.isHalfCalloriesAchievementReceived = true
        }

        if ((storage.calloriesGoal / newValue) <= 1.0) && !achievementsStorage.isFullCalloriesAchievementReceived {
            pushBurnedEnergyAchievement(.fullGoal)
            achievementsStorage.isFullCalloriesAchievementReceived = true
        }
    }

}
