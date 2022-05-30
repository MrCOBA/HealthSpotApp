import CaBRiblets

final class HealthActivityStatisticsTrackerBuilder: Builder {

    private let factory: RootServices

    init(factory: RootServices) {
        self.factory = factory
    }

    func build() -> Router {
        let interactor = HealthActivityStatisticsTrackerInteractorImpl(connection: factory.watchKitConnection,
                                                                       dataTracking: factory.dataTracking,
                                                                       statisticsStorage: factory.statisticsStorage,
                                                                       achievementsStorage: factory.achievementsStorage,
                                                                       localNotificationsAssistant: factory.localNotificationsAssistant)

        let router = HealthActivityStatisticsTrackerRouter(interactor: interactor)

        return router
    }

}
