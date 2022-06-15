import CaBRiblets

final class HealthActivityStatisticsTrackerBuilder: Builder {

    // MARK: - Private Properties
    
    private let factory: RootServices

    // MARK: - Init
    
    init(factory: RootServices) {
        self.factory = factory
    }

    // MARK: - Internal Methods
    
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
