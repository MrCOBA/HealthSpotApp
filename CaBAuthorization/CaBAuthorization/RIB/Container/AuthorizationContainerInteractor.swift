import Firebase
import CaBRiblets
import CaBFoundation

// MARK: - Listener

public protocol AuthorizationContainerListener: AnyObject {

    func completeAuthorization()

}

public final class AuthorizationContainerInteractor: BaseInteractor {

    // MARK: - Internal Properties

    weak var router: AuthorizationContainerRouter?

    // MARK: - Private Properties

    private weak var listener: AuthorizationContainerListener?

    private let coreDataAssistant: CoreDataAssistant
    private let credentialsStorage: AuthorithationCredentialsTemporaryStorage

    // MARK: - Init

    public init(coreDataAssistant: CoreDataAssistant, credentialsStorage: AuthorithationCredentialsTemporaryStorage, listener: AuthorizationContainerListener?) {
        self.coreDataAssistant = coreDataAssistant
        self.credentialsStorage = credentialsStorage
        self.listener = listener

        super.init()
    }

    // MARK: - Public Methods

    public override func start() {
        super.start()

        subscribeForNotifications()
    }

    // MARK: - Private Methods

    private func subscribeForNotifications() {
        // MARK: Success Auth
        let successNotifications: [Notification.Name] = [.Authorization.signIn(result: .success), .Authorization.signUp(result: .success)]
        successNotifications.forEach { notification in
            NotificationCenter.default.addObserver(self, selector: #selector(successAuthHandling(notification:)), name: notification, object: nil)
        }

        // MARK: Auth Failure
        let errorNotifications: [Notification.Name] = [
            .Authorization.firebaseSignInError,
            .Authorization.firebaseSignUpError,
            .Authorization.signIn(result: .failure(error: .incorrectFormat)),
            .Authorization.signIn(result: .failure(error: .notAllFieldsAreFilledIn)),
            .Authorization.signUp(result: .failure(error: .incorrectFormat)),
            .Authorization.signUp(result: .failure(error: .notAllFieldsAreFilledIn)),
            .Authorization.signUp(result: .failure(error: .passwordsDoNotMatch)),
            .Authorization.signUp(result: .failure(error: .noInternetConnection)),
            .Authorization.signIn(result: .failure(error: .noInternetConnection))]

        errorNotifications.forEach { notification in
            NotificationCenter.default.addObserver(self, selector: #selector(errorAuthHandling(notification:)), name: notification, object: nil)
        }
    }

    private func saveCredentials() {
        guard let user = coreDataAssistant.createEntity("User") else {
            logError(message: "Failed to create User entity")
            return
        }
        let userWrapper = UserEntityWrapper(entityObject: user, coreDataAssistant: coreDataAssistant)

        userWrapper.id = credentialsStorage.id
        userWrapper.email = credentialsStorage.email
        userWrapper.password = credentialsStorage.password

        credentialsStorage.clear()

        coreDataAssistant.saveData()
    }

    private func checkIfRouterSet() {
        guard router != nil else {
            logError(message: "Router expected to be set")
            return
        }
    }

    @objc
    private func successAuthHandling(notification: Notification) {
        switch notification.name {
        case .Authorization.signIn(result: .success):
            completeAuthorization()

        case .Authorization.signUp(result: .success):
            checkIfRouterSet()
            router?.attachScreen(for: .infoSuccess)

        default:
            logError(message: "Unknown notification recieved: <\(notification.name)>")
        }
    }

    @objc
    private func errorAuthHandling(notification: Notification) {
        switch notification.name {
        case .Authorization.firebaseSignInError,
             .Authorization.firebaseSignUpError:
            checkIfRouterSet()
            router?.attachScreen(for: .infoFailure)

        case .Authorization.signIn(result: .failure(error: .incorrectFormat)),
             .Authorization.signUp(result: .failure(error: .incorrectFormat)):
            checkIfRouterSet()
            router?.attachAlert(of: .incorrectFormat)

        case .Authorization.signIn(result: .failure(error: .notAllFieldsAreFilledIn)),
             .Authorization.signUp(result: .failure(error: .notAllFieldsAreFilledIn)):
            checkIfRouterSet()
            router?.attachAlert(of: .notAllFieldsAreFilledIn)

        case .Authorization.signUp(result: .failure(error: .passwordsDoNotMatch)):
            checkIfRouterSet()
            router?.attachAlert(of: .passwordsDoNotMatch)

        case .Authorization.signUp(result: .failure(error: .noInternetConnection)),
             .Authorization.signIn(result: .failure(error: .noInternetConnection)):
            checkIfRouterSet()
            router?.attachAlert(of: .noInternetConnection)

        default:
            logError(message: "Unknown notification recieved: <\(notification.name)>")
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

        saveCredentials()
        listener?.completeAuthorization()
    }

}
