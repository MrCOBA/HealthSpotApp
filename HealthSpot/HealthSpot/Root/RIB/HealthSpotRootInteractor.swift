import CaBRiblets
import CaBFoundation
import CaBAuthorization

protocol HealthSpotRootInteractor: Interactor,
                                   AuthorizationContainerListener {

}

final class HealthSpotRootInteractorImpl: BaseInteractor, HealthSpotRootInteractor {

    weak var router: HealthSpotRootRouter?

    private let authorizationManager: AuthorizationManager
    private let coreDataAssistant: CoreDataAssistant
    private let rootSettingsStorage: RootSettingsStorage
    private var user: User?

    private let notifications: [Notification.Name] = [
        .Authorization.firebaseSignInError,
        .Authorization.signIn(result: .success)
    ]

    init(authorizationManager: AuthorizationManager, coreDataAssistant: CoreDataAssistant, rootSettingsStorage: RootSettingsStorage) {
        self.authorizationManager = authorizationManager
        self.coreDataAssistant = coreDataAssistant
        self.rootSettingsStorage = rootSettingsStorage

        user = coreDataAssistant.loadData("User", predicate: nil, sortDescriptor: nil)?.firstObject as? User
    }

    override func start() {
        super.start()

        tryToSignIn()

        NotificationCenter.default.addObserver(self, selector: #selector(exitFromAccount), name: .exitFromAccount, object: nil)
    }

    override func stop() {
        NotificationCenter.default.removeObserver(self, name: .exitFromAccount, object: nil)

        super.stop()
    }

    private func subscribeForNotifications() {
        notifications.forEach { notification in
            NotificationCenter.default.addObserver(self, selector: #selector(notificationHandling(notification:)), name: notification, object: nil)
        }
    }

    private func unsubscribeForNotifications() {
        notifications.forEach { notification in
            NotificationCenter.default.removeObserver(self, name: notification, object: nil)
        }
    }
    
    private func tryToSignIn() {
        guard !rootSettingsStorage.isOfflineModeOn else {
            checkIfRouterSet()
            router?.attachMainFlow()
            return
        }

        guard let user = user else {
            checkIfRouterSet()
            router?.attachAuthorizationFlow()
            return
        }

        subscribeForNotifications()

        checkIfRouterSet()
        router?.attachWaitingRouter()
        
        authorizationManager.signIn(email: user.email ?? "", password: user.password ?? "")
    }

    @objc
    private func notificationHandling(notification: Notification) {
        unsubscribeForNotifications()
        switch notification.name {
        case .Authorization.signIn(result: .success):
            guard user?.id == notification.userInfo?["id"] as? String else {
                coreDataAssistant.removeData("User", predicate: nil, sortDescriptor: nil)
                checkIfRouterSet()
                router?.attachAuthorizationFlow()
                return
            }

            completeAuthorization()

        case .Authorization.firebaseSignInError:
            checkIfRouterSet()
            router?.attachAuthorizationFlow()

        default:
            logError(message: "Unknown notification recieved: <\(notification.name)>")
        }
    }

    @objc
    private func exitFromAccount() {
        coreDataAssistant.removeData("User", predicate: nil, sortDescriptor: nil)
        coreDataAssistant.saveData()
        router?.attachAuthorizationFlow()
    }

    private func checkIfRouterSet() {
        guard router != nil else {
            logError(message: "Router expected to be set")
            return
        }
    }

}

extension HealthSpotRootInteractorImpl: AuthorizationContainerListener {

    func completeAuthorization() {
        checkIfRouterSet()
        router?.attachMainFlow()
    }

}
