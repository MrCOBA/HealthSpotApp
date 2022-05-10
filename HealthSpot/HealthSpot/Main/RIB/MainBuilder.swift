import CaBRiblets

final class MainBuilder: Builder {

    func build() -> ViewableRouter {
        let view = MainView()

        let interactor = MainInteractorImpl()
        let router = MainRouterImpl(view: view, interactor: interactor)

        return router
    }

}
