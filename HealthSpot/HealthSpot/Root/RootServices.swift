import UIKit
import CoreData
import CaBFirebaseKit
import CaBAuthorization
import CaBMedicineChecker
import CaBUIKit
import CaBSDK

protocol RootServices: AuthorizationRootServices, MedicineCheckerRootServices {

    // MARK: RootServices

    var colorScheme: CaBColorScheme { get }
    var coreDataAssistant: CoreDataAssistant { get }
    var firebaseServices: FirebaseServicesProvider { get }

    // MARK: AuthorizationRootServices

    var authorizationManager: AuthorizationManager { get }
    var credentialsStorage: AuthorithationCredentialsTemporaryStorage { get }

    // MARK: MedicineCheckerRootServices

    var medicineItemPeriodStorage: MedicineItemPeriodTemporaryStorage { get }
    
}

final class RootServicesImpl: RootServices {

    private var context: NSManagedObjectContext?
    let coreDataAssistant: CoreDataAssistant

    var colorScheme: CaBColorScheme
    let firebaseServices: FirebaseServicesProvider

    let authorizationManager: AuthorizationManager
    let credentialsStorage: AuthorithationCredentialsTemporaryStorage

    let medicineItemPeriodStorage: MedicineItemPeriodTemporaryStorage

    init() {
        colorScheme = .default
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            context = appDelegate.persistentContainer.viewContext
        }
        coreDataAssistant = CoreDataAssistantImpl(context: context)
        firebaseServices = FirebaseServicesProviderImpl()

        medicineItemPeriodStorage = MedicineItemPeriodTemporaryStorageImpl()
        credentialsStorage = AuthorithationCredentialsTemporaryStorageImpl()

        authorizationManager = AuthorizationManagerImpl(authorizationController: firebaseServices.authorizationController,
                                                        coreDataAssistant: coreDataAssistant,
                                                        temporaryCredentialsStorage: credentialsStorage)
    }

}
