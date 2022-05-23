import UIKit
import CoreData
import CaBFirebaseKit
import CaBAuthorization
import CaBMedicineChecker
import CaBUIKit
import CaBFoundation

protocol RootServices: AuthorizationRootServices, MedicineCheckerRootServices {

    // MARK: RootServices

    var colorScheme: CaBColorScheme { get }
    var coreDataAssistant: CoreDataAssistant { get }
    var rootSettingsStorage: RootSettingsStorage { get }
    var localNotificationsAssistant: LocalNotificationAssistant { get }
    var firebaseServices: FirebaseServicesProvider { get }

    // MARK: AuthorizationRootServices

    var authorizationManager: AuthorizationManager { get }
    var credentialsStorage: AuthorithationCredentialsTemporaryStorage { get }

    // MARK: MedicineCheckerRootServices

    var medicineItemPeriodStorage: MedicineItemPeriodTemporaryStorage { get }
    var firebaseFirestoreMedicineCheckerController: FirebaseFirestoreMedicineCheckerController { get }
    
}

final class RootServicesImpl: RootServices {

    private var context: NSManagedObjectContext?
    let coreDataAssistant: CoreDataAssistant

    let rootSettingsStorage: RootSettingsStorage
    let localNotificationsAssistant: LocalNotificationAssistant

    var colorScheme: CaBColorScheme
    let firebaseServices: FirebaseServicesProvider

    let authorizationManager: AuthorizationManager
    let credentialsStorage: AuthorithationCredentialsTemporaryStorage

    let medicineItemPeriodStorage: MedicineItemPeriodTemporaryStorage
    let firebaseFirestoreMedicineCheckerController: FirebaseFirestoreMedicineCheckerController

    init() {
        colorScheme = .default
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            context = appDelegate.persistentContainer.viewContext
        }
        coreDataAssistant = CoreDataAssistantImpl(context: context)

        rootSettingsStorage = RootSettingsStorageImpl()
        localNotificationsAssistant = LocalNotificationAssistantImpl(storage: rootSettingsStorage)

        firebaseServices = FirebaseServicesProviderImpl(coreDataAssistant: coreDataAssistant)

        medicineItemPeriodStorage = MedicineItemPeriodTemporaryStorageImpl()
        firebaseFirestoreMedicineCheckerController = firebaseServices.firebaseFirestoreMedicineCheckerController
        credentialsStorage = AuthorithationCredentialsTemporaryStorageImpl()

        authorizationManager = AuthorizationManagerImpl(authorizationController: firebaseServices.authorizationController,
                                                        coreDataAssistant: coreDataAssistant,
                                                        temporaryCredentialsStorage: credentialsStorage)
    }

}
