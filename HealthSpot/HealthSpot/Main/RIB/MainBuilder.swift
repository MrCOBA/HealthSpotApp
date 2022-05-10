import CaBRiblets

final class MainBuilder: Builder {

    func build() -> ViewableRouter {
        let view = MainView()

        let interactor = MainInteractorImpl()
        view.eventsHandler = interactor

        let router = MainRouterImpl(view: view, interactor: interactor)
        interactor.router = router

        return router
    }

}
