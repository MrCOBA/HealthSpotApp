import CaBRiblets
import CaBSDK

// MARK: - Protocols

public protocol AuthorizationListener: AnyObject {
    func showSignUpScreen()
    func returnBackToSignIn()
    func completeAuthorization()
}

public protocol AuthorizationInteractor: Interactor {

    func signIn(with credentials: [Int: String])
    func signUp(with credentials: [Int: String])
    func showSignUpScreen()
    func returnBack()
    func completeAuthorization()

}

// MARK: - Implementation

public final class AuthorizationInteractorImpl: BaseInteractor, AuthorizationInteractor {

    // MARK: - Private Types

    private enum CredentialKey: Int {
        case email = 0
        case password
        case repeatedPassword
    }

    // MARK: - Internal Properties

    weak var listener: AuthorizationListener?
    weak var presenter: AuthorizationPresenter?

    // MARK: - Private Properties

    private var mode: AuthorizationViewModel.Mode
    private let authorizationManager: AuthorizationManager
    private let temporaryCredentialsStorage: AuthorithationCredentialsTemporaryStorage

    // MARK: - Init

    public init(mode: AuthorizationViewModel.Mode,
                authorizationManager: AuthorizationManager,
                temporaryCredentialsStorage: AuthorithationCredentialsTemporaryStorage,
                listener: AuthorizationListener?) {
        self.mode = mode
        self.authorizationManager = authorizationManager
        self.temporaryCredentialsStorage = temporaryCredentialsStorage
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
        if case .signIn = mode {
            updateStorage(with: credentials)
        }
        authorizationManager.signIn()
    }

    public func signUp(with credentials: [Int : String]) {
        if case .signUp = mode {
            updateStorage(with: credentials)
        }
        authorizationManager.signUp()
    }

    public func showSignUpScreen() {
        checkIfListenerSet()
        listener?.showSignUpScreen()
    }

    public func returnBack() {
        checkIfListenerSet()
        listener?.returnBackToSignIn()
    }

    public func completeAuthorization() {
        checkIfListenerSet()
        listener?.completeAuthorization()
    }

    // MARK: - Private Methods

    private func updateStorage(with credentials: [Int : String]) {
        credentials.forEach { key, value in
            guard let credentialKey = CredentialKey(rawValue: key) else {
                logError(message: "Unexpected credential key: <\(key)>")
                return
            }

            updateStoredValue(for: credentialKey, with: value)
        }
    }

    private func updateStoredValue(for key: CredentialKey, with value: String) {
        switch key {
        case .email:
            temporaryCredentialsStorage.email = value

        case .password:
            temporaryCredentialsStorage.password = value

        case .repeatedPassword:
            temporaryCredentialsStorage.repeatedPassword = value
        }
    }

    private func checkIfListenerSet() {
        guard listener != nil else {
            logError(message: "Listener expected to be set")
            return
        }
    }

}

