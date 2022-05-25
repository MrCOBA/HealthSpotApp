import CaBRiblets
import CaBUIKit

// MARK: - Builder

final class HomeContainerBuilder: Builder {

    // MARK: - Private Properties

    private weak var listener: HomeContainerListener?
    private let factory: RootServices

    // MARK: -  Init

    init(factory: RootServices, listener: HomeContainerListener?) {
        self.factory = factory
        self.listener = listener
    }

    // MARK: - Internal Methods

    func build() -> ViewableRouter {
        let view = CaBNavigationController()
        view.isNavigationBarHidden = false
        view.colorScheme = factory.colorScheme

        let interactor = HomeContainerInteractor(listener: listener)

        let router = HomeContainerRouterImpl(rootServices: factory, view: view, interactor: interactor)
        interactor.router = router

        return router
    }

}
