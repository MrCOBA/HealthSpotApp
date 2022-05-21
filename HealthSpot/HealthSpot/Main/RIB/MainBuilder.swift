import CaBRiblets

final class MainBuilder: Builder {

    private let factory: RootServices

    init(factory: RootServices) {
        self.factory = factory
    }

    func build() -> ViewableRouter {
        let view = MainView()

        let interactor = MainInteractorImpl()

        let presenter = MainPresenterImpl(view: view, interactor: interactor)
        view.eventsHandler = presenter
        interactor.presenter = presenter

        let router = MainRouterImpl(rootServices: factory, view: view, interactor: interactor)
        interactor.router = router

        return router
    }

}
