import CaBRiblets
import UIKit

public final class AuthorizationBuilder: Builder {

    // MARK: - Private Properties

    private let factory: AuthorizationRootServices
    private weak var listener: AuthorizationListener?

    // MARK: - Init

    public init(factory: AuthorizationRootServices, listener: AuthorizationListener?) {
        self.factory = factory
        self.listener = listener
    }

    // MARK: - Public Methods

    public func build(mode: AuthorizationViewModel.Mode) -> ViewableRouter {
        let view: AuthorizationView & UIViewController

        switch mode {
        case .signIn,
             .signUp:
            view = AuthorizationViewImpl.makeView()

        case .infoSuccess,
             .infoFailure:
            view = AuthorizationInfoViewImpl.makeView()
        }

        let interactor = AuthorizationInteractorImpl(mode: mode,
                                                     authorizationManager: factory.authorizationManager,
                                                     temporaryCredentialsStorage: factory.credentialsStorage,
                                                     listener: listener)
        let presenter = AuthorizationPresenterImpl(view: view, interactor: interactor)
        view.eventsHandler = presenter
        
        interactor.presenter = presenter

        let router = AuthorizationRouter(view: view, interactor: interactor)

        return router
    }
    
}
