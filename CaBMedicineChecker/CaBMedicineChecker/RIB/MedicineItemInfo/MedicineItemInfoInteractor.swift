import CoreData
import CaBRiblets
import CaBFoundation
import CaBFirebaseKit

// MARK: - Protocols

protocol MedicineItemInfoListener: AnyObject {

    func closeScreen()

}

protocol MedicineItemInfoInteractor: Interactor, MedicineItemPeriodListener {

    func didFinish()
    func showItemPeriodScreen(with actionType: MedicineItemPeriodActionType)

}

// MARK: - Implementation

final class MedicineItemInfoInteractorImpl: BaseInteractor, MedicineItemInfoInteractor {

    // MARK: - Internal Properties

    weak var listener: MedicineItemInfoListener?
    weak var router: MedicineItemInfoRouter?
    var presenter: MedicineItemInfoPresenter?

    // MARK: - Private Properties

    private let firebaseFirestoreMedicineCheckerController: FirebaseFirestoreMedicineCheckerController
    private let itemPeriodTemporaryStorage: MedicineItemPeriodTemporaryStorage
    private let coreDataAssistant: CoreDataAssistant

    private let entityId: String
    private var medicineItem: MedicineItemEntityWrapper?
    private var periods = [MedicineItemPeriodEntityWrapper]()

    // MARK: - Init

    init(firebaseFirestoreMedicineCheckerController: FirebaseFirestoreMedicineCheckerController,
         itemPeriodTemporaryStorage: MedicineItemPeriodTemporaryStorage,
         coreDataAssistant: CoreDataAssistant,
         presenter: MedicineItemInfoPresenter,
         entityId: String,
         listener: MedicineItemInfoListener?) {
        self.firebaseFirestoreMedicineCheckerController = firebaseFirestoreMedicineCheckerController
        self.itemPeriodTemporaryStorage = itemPeriodTemporaryStorage
        self.entityId = entityId
        self.presenter = presenter
        self.coreDataAssistant = coreDataAssistant
        self.listener = listener
    }

    // MARK: - Internal Methods

    override func start() {
        super.start()

        firebaseFirestoreMedicineCheckerController.addObserver(self)
        syncStorage()
    }

    override func stop() {
        firebaseFirestoreMedicineCheckerController.removeObserver(self)

        super.stop()
    }

    func showItemPeriodScreen(with actionType: MedicineItemPeriodActionType) {
        checkIfRouterSet()

        router?.attachItemPeriodRouter(with: actionType)
    }

    func didFinish() {
        checkIfListenerSet()

        listener?.closeScreen()
    }

    // MARK: - Private Methods

    private func syncStorage() {
        medicineItem = loadEntity(with: entityId)
        periods = loadPeriods(from: medicineItem?.periods)

        updateView()
    }

    private func updateView() {
        guard let medicineItem = medicineItem else {
            logWarning(message: "Failed to load medicineItem")
            return
        }

        presenter?.updateView(rawData: medicineItem, periods)
    }

    private func loadEntity(with id: String) -> MedicineItemEntityWrapper? {
        return MedicineItemEntityWrapper(id: id, coreDataAssistant: coreDataAssistant)
    }

    private func loadPeriods(from rawData: NSMutableArray?) -> [MedicineItemPeriodEntityWrapper] {
        guard let rawData = rawData else {
            logWarning(message: "Failed to load periods")
            return []
        }

        let periods: [MedicineItemPeriodEntityWrapper] = rawData.compactMap {
            guard let rawPeriod = $0 as? NSManagedObject else {
                return nil
            }

            return MedicineItemPeriodEntityWrapper(entityObject: rawPeriod, coreDataAssistant: coreDataAssistant)
        }

        return periods
    }

    private func checkIfRouterSet() {
        if router == nil {
            logError(message: "Router expected to be set")
        }
    }

    private func checkIfListenerSet() {
        if listener == nil {
            logError(message: "Listener expected to be set")
        }
    }

}

// MARK: - Protocol MedicineItemPeriodListener

extension MedicineItemInfoInteractorImpl: MedicineItemPeriodListener {

    func updatePeriod(with actionType: MedicineItemPeriodActionType) {
        guard let user = UserEntityWrapper(coreDataAssistant: coreDataAssistant) else {
            return
        }

        switch actionType {
        case .add:
            firebaseFirestoreMedicineCheckerController.addMedicineItemPeriod(data: itemPeriodTemporaryStorage.json(),
                                                                             toItem: entityId,
                                                                             ofUser: user.id)
        case .edit(let id):
            firebaseFirestoreMedicineCheckerController.updateMedicineItemPeriod(data: itemPeriodTemporaryStorage.json(),
                                                                                of: id,
                                                                                inItem: entityId,
                                                                                ofUser: user.id)
        case .delete(let id):
            firebaseFirestoreMedicineCheckerController.deleteMedicineItemPeriod(with: id,
                                                                                fromItem: entityId,
                                                                                ofUser: user.id)
        }

        closeItemPeriodEditorScreen()
    }

    func closeItemPeriodEditorScreen() {
        checkIfRouterSet()
        itemPeriodTemporaryStorage.clear()

        router?.detachItemPeriodRouter()
    }

}

// MARK: - Protocol FirebaseFirestoreMedicineCheckerDelegate

extension MedicineItemInfoInteractorImpl: FirebaseFirestoreMedicineCheckerDelegate {

    func didFinishStorageUpdate(with error: Error?) {
        guard error == nil else {
            return
        }
        
        syncStorage()
    }

    func didFinishUpload(with error: Error?) {
        guard error == nil else {
            return
        }

        guard let user = UserEntityWrapper(coreDataAssistant: coreDataAssistant) else {
            return
        }
        
        firebaseFirestoreMedicineCheckerController.updateData(for: user.id)
    }

}
