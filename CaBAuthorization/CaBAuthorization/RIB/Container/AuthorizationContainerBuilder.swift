import CaBRiblets
import CaBUIKit

// MARK: - Builder

public final class AuthorizationContainerBuilder: Builder {

    // MARK: - Private Properties

    private weak var listener: AuthorizationContainerListener?

    // MARK: -  Init

    public init(listener: AuthorizationContainerListener?) {
        self.listener = listener
    }

    // MARK: - Public Methods

    public func build() -> ViewableRouter {
        let view = CaBNavigationController()
        view.isNavigationBarHidden = true

        let interactor = AuthorizationContainerInteractor(listener: listener)

        let router = AuthorizationContainerRouterImpl(view: view, interactor: interactor)
        interactor.router = router

        return router
    }

}
