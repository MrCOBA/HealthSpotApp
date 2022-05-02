import CaBRiblets

public final class AuthorizationBuilder: Builder {

    private weak var listener: AuthorizationListener?

    public init(listener: AuthorizationListener?) {
        self.listener = listener
    }

    public func build(mode: AuthorizationViewModel.Mode) -> ViewableRouter {
        switch mode {
        case .signIn,
             .signUp:
            return buildAuthorizationView(mode: mode)

        case .infoSuccess,
             .infoFailure:
            fatalError("Unexpected authorization mode: <\(mode)>")
        }

    }

    private func buildAuthorizationView(mode: AuthorizationViewModel.Mode) -> ViewableRouter {
        let view = AuthorizationViewImpl.makeView()

        let presenter = AuthorizationPresenterImpl(view: view)

        let authorizationManager = AuthorizationManagerImpl()
        let interactor = AuthorizationInteractorImpl(mode: mode, authorizationManager: authorizationManager, listener: listener)
        interactor.presenter = presenter

        let router = AuthorizationRouter(view: view, interactor: interactor)

        return router
    }

}
