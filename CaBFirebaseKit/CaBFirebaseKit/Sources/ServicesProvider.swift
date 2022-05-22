import Firebase
import CaBSDK

// MARK: - Protocol

public protocol FirebaseServicesProvider: AnyObject {

    var authorizationController: FirebaseAuthorizationController { get }
    var firebaseFirestoreMedicineCheckerController: FirebaseFirestoreMedicineCheckerController { get }

}

// MARK: - Implementation

public final class FirebaseServicesProviderImpl: FirebaseServicesProvider {

    // MARK: - Public Properties
    
    public let authorizationController: FirebaseAuthorizationController
    public let firebaseFirestoreMedicineCheckerController: FirebaseFirestoreMedicineCheckerController

    // MARK: - Init

    public init(coreDataAssistant: CoreDataAssistant) {
        FirebaseApp.configure()

        authorizationController = FirebaseAuthorizationControllerImpl()
        firebaseFirestoreMedicineCheckerController = FirebaseFirestoreMedicineCheckerControllerImpl(coreDataAssistant: coreDataAssistant)
    }

}
