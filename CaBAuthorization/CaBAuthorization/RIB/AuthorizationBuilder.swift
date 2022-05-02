import CaBRiblets

public final class AuthorizationBuilder: Builder {

    private weak var listener: AuthorizationListener?

    public init(listener: AuthorizationListener?) {
        self.listener = listener
    }

    public func build(mode: AuthorizationViewModel.Mode) -> ViewableRouter {
        let view: AuthorizationView

        switch mode {
        case .signIn,
             .signUp:
            view = AuthorizationViewImpl.makeView()

        case .infoSuccess,
             .infoFailure:
            view = AuthorizationInfoViewImpl.makeView()
        }

        let storage = AuthorithationCredentialsTemporaryStorageImpl()
        let authorizationManager = AuthorizationManagerImpl(temporaryCredentialsStorage: storage)

        let interactor = AuthorizationInteractorImpl(mode: mode,
                                                     authorizationManager: authorizationManager,
                                                     temporaryCredentialsStorage: storage,
                                                     listener: listener)
        let presenter = AuthorizationPresenterImpl(view: view, interactor: interactor)
        
        interactor.presenter = presenter

        let router = AuthorizationRouter(view: view, interactor: interactor)

        return router
    }
    
}
