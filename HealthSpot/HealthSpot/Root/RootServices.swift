import UIKit
import CoreData
import CaBAuthorization
import CaBBarcodeReader

protocol RootServices: AuthorizationRootServices, MedicineCheckerRootServices {

    // MARK: RootServices
    
    var coreDataAssistant: CoreDataAssistant { get }

    // MARK: AuthorizationRootServices

    var authorizationManager: AuthorizationManager { get }
    var credentialsStorage: AuthorithationCredentialsTemporaryStorage { get }

    // MARK: MedicineCheckerRootServices

    var medicineItemPeriodStorage: MedicineItemPeriodTemporaryStorage { get }
    
}

final class RootServicesImpl: RootServices {

    private var context: NSManagedObjectContext?
    let coreDataAssistant: CoreDataAssistant

    let authorizationManager: AuthorizationManager
    let credentialsStorage: AuthorithationCredentialsTemporaryStorage

    let medicineItemPeriodStorage: MedicineItemPeriodTemporaryStorage

    init() {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            context = appDelegate.persistentContainer.viewContext
        }
        coreDataAssistant = CoreDataAssistantImpl(context: context)

        medicineItemPeriodStorage = MedicineItemPeriodTemporaryStorageImpl()
        credentialsStorage = AuthorithationCredentialsTemporaryStorageImpl()

        authorizationManager = AuthorizationManagerImpl(temporaryCredentialsStorage: credentialsStorage)
    }

}
