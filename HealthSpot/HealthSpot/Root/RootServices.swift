import CaBAuthorization
import CaBBarcodeReader

protocol RootServices: AuthorizationRootServices, MedicineCheckerRootServices {

    var authorizationManager: AuthorizationManager { get }
    var credentialsStorage: AuthorithationCredentialsTemporaryStorage { get }

    var medicineItemPeriodStorage: MedicineItemPeriodTemporaryStorage { get }
    
}

final class RootServicesImpl: RootServices {

    let authorizationManager: AuthorizationManager
    let credentialsStorage: AuthorithationCredentialsTemporaryStorage
    let medicineItemPeriodStorage: MedicineItemPeriodTemporaryStorage

    init() {
        medicineItemPeriodStorage = MedicineItemPeriodTemporaryStorageImpl()
        credentialsStorage = AuthorithationCredentialsTemporaryStorageImpl()

        authorizationManager = AuthorizationManagerImpl(temporaryCredentialsStorage: credentialsStorage)
    }

}
