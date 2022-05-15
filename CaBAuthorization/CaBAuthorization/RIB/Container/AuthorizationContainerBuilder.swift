import CaBRiblets
import CaBUIKit

// MARK: - Builder

public final class AuthorizationContainerBuilder: Builder {

    // MARK: - Private Properties

    private let factory: AuthorizationRootServices
    private weak var listener: AuthorizationContainerListener?

    // MARK: -  Init

    public init(factory: AuthorizationRootServices, listener: AuthorizationContainerListener?) {
        self.factory = factory
        self.listener = listener
    }

    // MARK: - Public Methods

    public func build() -> ViewableRouter {
        let view = CaBNavigationController()
        view.isNavigationBarHidden = true

        let interactor = AuthorizationContainerInteractor(listener: listener)

        let router = AuthorizationContainerRouterImpl(rootServices: factory, view: view, interactor: interactor)
        interactor.router = router

        return router
    }

}
