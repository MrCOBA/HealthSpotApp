import CaBRiblets
import CaBSDK

// MARK: - Protocols

public protocol AuthorizationListener: AnyObject {
    func showSignUpScreen()
    func returnBack()
}

public protocol AuthorizationInteractor: Interactor {

    func signIn(with credentials: [Int: String])
    func signUp(with credentials: [Int: String])
    func showSignUpScreen()
    func returnBack()

}

// MARK: - Implementation

public final class AuthorizationInteractorImpl: BaseInteractor, AuthorizationInteractor {

    // MARK: - Internal Properties

    weak var listener: AuthorizationListener?
    weak var presenter: AuthorizationPresenter?

    // MARK: - Private Properties

    private var mode: AuthorizationViewModel.Mode
    private let authorizationManager: AuthorizationManager

    // MARK: - Init

    public init(mode: AuthorizationViewModel.Mode, authorizationManager: AuthorizationManager, listener: AuthorizationListener?) {
        self.mode = mode
        self.authorizationManager = authorizationManager
        self.listener = listener
    }

    // MARK: - Public Methods

    // MARK: Overrides

    public override func start() {
        super.start()

        presenter?.update(for: mode)
    }

    // MARK: Protocol AuthorizationInteractor

    public func signIn(with credentials: [Int : String]) {
        authorizationManager.signIn(with: credentials)
    }

    public func signUp(with credentials: [Int : String]) {
        authorizationManager.signUp(with: credentials)
    }

    public func showSignUpScreen() {
        checkIfListenerSet()
        listener?.showSignUpScreen()
    }

    public func returnBack() {
        checkIfListenerSet()
        listener?.returnBack()
    }

    // MARK: - Private Methods

    private func checkIfListenerSet() {
        guard listener != nil else {
            logError(message: "Listener expected to be set")
            return
        }
    }

}

