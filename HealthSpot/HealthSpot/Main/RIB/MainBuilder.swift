import CaBRiblets

final class MainBuilder: Builder {

    func build() -> ViewableRouter {
        let view = MainView()

        let interactor = MainInteractorImpl()

        let presenter = MainPresenterImpl(view: view, interactor: interactor)
        view.eventsHandler = presenter
        interactor.presenter = presenter

        let router = MainRouterImpl(view: view, interactor: interactor)
        interactor.router = router

        return router
    }

}
