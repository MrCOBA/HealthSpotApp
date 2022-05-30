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
    var networkMonitor: NetworkMonitor { get }
    var coreDataAssistant: CoreDataAssistant { get }
    var rootSettingsStorage: RootSettingsStorage { get }
    var localNotificationsAssistant: LocalNotificationAssistant { get }
    var localNotificationsScheduler: LocalNotificationsScheduler { get }
    var firebaseServices: FirebaseServicesProvider { get }
    var statisticsStorage: HealthActivityStatisticsStorage { get }
    var cachedStorage: CachedStorage { get }
    var dataTracking: HealthDataTracking { get }
    var watchKitConnection: WatchKitConnection { get }

    // MARK: AuthorizationRootServices

    var authorizationManager: AuthorizationManager { get }
    var credentialsStorage: AuthorithationCredentialsTemporaryStorage { get }

    // MARK: MedicineCheckerRootServices

    var medicineItemPeriodStorage: MedicineItemPeriodTemporaryStorage { get }
    var firebaseFirestoreMedicineCheckerController: FirebaseFirestoreMedicineCheckerController { get }
    
}

final class RootServicesImpl: RootServices {

    private var context: NSManagedObjectContext?
    private let suiteProvider = UserDefaultsSuiteProvider()

    let networkMonitor: NetworkMonitor

    let coreDataAssistant: CoreDataAssistant

    let rootSettingsStorage: RootSettingsStorage
    let localNotificationsAssistant: LocalNotificationAssistant
    let localNotificationsScheduler: LocalNotificationsScheduler

    let colorScheme: CaBColorScheme
    let firebaseServices: FirebaseServicesProvider
    let statisticsStorage: HealthActivityStatisticsStorage
    let cachedStorage: CachedStorage
    let dataTracking: HealthDataTracking
    let watchKitConnection: WatchKitConnection

    let authorizationManager: AuthorizationManager
    let credentialsStorage: AuthorithationCredentialsTemporaryStorage

    let medicineItemPeriodStorage: MedicineItemPeriodTemporaryStorage
    let firebaseFirestoreMedicineCheckerController: FirebaseFirestoreMedicineCheckerController

    init() {
        colorScheme = .default
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            context = appDelegate.persistentContainer.viewContext
        }
        networkMonitor = NetworkMonitorImpl()
        coreDataAssistant = CoreDataAssistantImpl(context: context)

        rootSettingsStorage = RootSettingsStorageImpl(userDefaults: suiteProvider.suite(type: RootSettingsStorage.self) ?? .standard)
        
        localNotificationsAssistant = LocalNotificationAssistantImpl(storage: rootSettingsStorage)

        firebaseServices = FirebaseServicesProviderImpl(coreDataAssistant: coreDataAssistant)

        medicineItemPeriodStorage = MedicineItemPeriodTemporaryStorageImpl()
        firebaseFirestoreMedicineCheckerController = firebaseServices.firebaseFirestoreMedicineCheckerController

        localNotificationsScheduler = LocalNotificationsSchedulerImpl(storage: rootSettingsStorage,
                                                                      localNotificationsAssistant: localNotificationsAssistant,
                                                                      firebaseFirestoreMedicineCheckerController: firebaseFirestoreMedicineCheckerController,
                                                                      coreDataAssistant: coreDataAssistant)

        credentialsStorage = AuthorithationCredentialsTemporaryStorageImpl()

        authorizationManager = AuthorizationManagerImpl(networkMonitor: networkMonitor,
                                                        authorizationController: firebaseServices.authorizationController,
                                                        coreDataAssistant: coreDataAssistant,
                                                        temporaryCredentialsStorage: credentialsStorage)

        statisticsStorage = HealthActivityStatisticsStorageImpl(userDefults: suiteProvider.suite(type: HealthActivityStatisticsStorage.self) ?? .standard)
        cachedStorage = CachedStorageImpl(userDefaults: suiteProvider.suite(type: CachedStorage.self) ?? .standard)

        dataTracking = HealthDataTrackingImpl(statisticsStorage: statisticsStorage)
        watchKitConnection = WatchKitConnectionImpl(statisticsStorage: statisticsStorage)

        watchKitConnection.startSession()
        networkMonitor.startMonitoring()
    }

    deinit {
        networkMonitor.stopMonitoring()
    }

}
