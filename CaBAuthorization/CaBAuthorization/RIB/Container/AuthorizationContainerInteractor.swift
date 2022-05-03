import Firebase
import CaBRiblets
import CaBSDK

// MARK: - Listener

public protocol AuthorizationContainerListener: AnyObject {

    func completeAuthorization()

}

public final class AuthorizationContainerInteractor: BaseInteractor {

    // MARK: - Internal Properties

    weak var router: AuthorizationContainerRouter?

    // MARK: - Private Properties

    private weak var listener: AuthorizationContainerListener?

    // MARK: - Init

    public init(listener: AuthorizationContainerListener?) {
        self.listener = listener
        FirebaseApp.configure()

        super.init()
    }

    // MARK: - Private Methods

    private func checkIfRouterSet() {
        guard router != nil else {
            logError(message: "Router expected to be set")
            return
        }
    }

}

// MARK: - Protocol AuthorizationListener

extension AuthorizationContainerInteractor: AuthorizationListener {

    public func showSignUpScreen() {
        checkIfRouterSet()
        router?.attachScreen(for: .signUp)
    }

    public func returnBackToSignIn() {
        checkIfRouterSet()
        router?.attachScreen(for: .signIn)
    }

    public func completeAuthorization() {
        guard listener != nil else {
            logError(message: "Listener expected to be set")
            return
        }

        listener?.completeAuthorization()
    }

}
