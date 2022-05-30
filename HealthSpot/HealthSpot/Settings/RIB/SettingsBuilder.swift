import CaBRiblets

final class SettingsBuilder: Builder {

    // MARK: - Private Properties

    private let factory: RootServices

    // MARK: - Init

    init(factory: RootServices) {
        self.factory = factory
    }

    // MARK: - Internal Methods

    func build() -> ViewableRouter {
        let view = SettingsView.makeView()

        let presenter = SettingsPresenterImpl(view: view,
                                              healthActivityStatisticsStorage: factory.statisticsStorage,
                                              rootSettingsStorage: factory.rootSettingsStorage)
        view.eventsHandler = presenter
        
        let interactor = SettingsInteractorImpl(presenter: presenter,
                                                healthActivityStatisticsStorage: factory.statisticsStorage,
                                                rootSettingsStorage: factory.rootSettingsStorage)

        presenter.interactor = interactor

        let router = SettingsRouterImpl(rootServices: factory, view: view, interactor: interactor)
        interactor.router = router

        return router
    }

}
