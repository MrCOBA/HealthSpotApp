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
        router?.attachSignUpScreen()
    }

    public func returnBackToSignIn() {
        checkIfRouterSet()
        router?.attachSignInScreen()
    }

    public func completeAuthorization() {
        guard listener != nil else {
            logError(message: "Listener expected to be set")
            return
        }

        listener?.completeAuthorization()
    }

}
