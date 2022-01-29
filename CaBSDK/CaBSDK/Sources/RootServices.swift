import Firebase

// MARK: - Protocol

public protocol RootServices: AnyObject {

    var autorizationManager: AuthorizationManager { get }

}

// MARK: - Implementation

public final class RootServicesImpl: RootServices {

    // MARK: - Public Properties
    
    public let autorizationManager: AuthorizationManager

    // MARK: - Init

    public init() {
        autorizationManager = AuthorizationManagerImpl()
    }

    // MARK: - Public Methods

    public func configure() {
        FirebaseApp.configure()
    }

}
