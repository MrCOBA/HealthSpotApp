import CaBRiblets

final class HomeBuilder: Builder {

    // MARK: - Private Properties

    private let factory: RootServices

    // MARK: - Init

    init(factory: RootServices) {
        self.factory = factory
    }

    // MARK: - Internal Methods

    func build() -> ViewableRouter {
        let view = HomeView.makeView()

        let presenter = HomePresenterImpl(view: view)
        view.eventsHandler = presenter
        
        let interactor = HomeInteractorImpl(statisticsStorage: factory.statisticsStorage,
                                            presenter: presenter)

        presenter.interactor = interactor

        let router = HomeRouterImpl(rootServices: factory, view: view, interactor: interactor)
        interactor.router = router

        return router
    }

}
