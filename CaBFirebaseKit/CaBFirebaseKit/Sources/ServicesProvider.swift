import Firebase

// MARK: - Protocol

public protocol FirebaseServicesProvider: AnyObject {

    var authorizationController: FirebaseAuthorizationController { get }

}

// MARK: - Implementation

public final class FirebaseServicesProviderImpl: FirebaseServicesProvider {

    // MARK: - Public Properties
    
    public let authorizationController: FirebaseAuthorizationController

    // MARK: - Init

    public init() {
        FirebaseApp.configure()

        authorizationController = FirebaseAuthorizationControllerImpl()
    }

}
