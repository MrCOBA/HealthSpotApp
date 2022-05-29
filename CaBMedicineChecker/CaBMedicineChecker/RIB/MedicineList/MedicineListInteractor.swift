import CoreData
import CaBRiblets
import CaBFoundation
import CaBFirebaseKit

// MARK: - Protocols

protocol MedicineListListener: AnyObject {

    func didObtainError(_ error: Error)

}

protocol MedicineListInteractor: Interactor, MedicineItemInfoListener, BarcodeCaptureListener {

    func showMedicineItemInfoScreen(with id: String)
    func showBarcodeScannerScreen()
    func updateDisplyingMedicineItems(filteredBy date: Date?)

}

// MARK: - Implementation

final class MedicineListInteractorImpl: BaseInteractor, MedicineListInteractor {

    // MARK: - Internal Types

    typealias MedicineItemCompositeWrapper = CompositeCollectionWrapper<MedicineItemEntityWrapper, MedicineItemPeriodEntityWrapper>

    // MARK: - Internal Properties

    weak var router: MedicineListRouter?
    var presenter: MedicineListPresenter?

    // MARK: - Private Properties

    private weak var listener: MedicineListListener?
    private let coreDataAssistant: CoreDataAssistant
    private let firebaseFirestoreMedicineCheckerController: FirebaseFirestoreMedicineCheckerController
    private var user: UserEntityWrapper?
    private var medicineItems = [MedicineItemCompositeWrapper]()

    // MARK: - Init

    init(coreDataAssistant: CoreDataAssistant,
         presenter: MedicineListPresenter,
         firebaseFirestoreMedicineCheckerController: FirebaseFirestoreMedicineCheckerController,
         listener: MedicineListListener?) {
        self.coreDataAssistant = coreDataAssistant
        self.presenter = presenter
        self.firebaseFirestoreMedicineCheckerController = firebaseFirestoreMedicineCheckerController
        self.listener = listener
    }

    // MARK: - Internal Methods

    override func start() {
        super.start()

        firebaseFirestoreMedicineCheckerController.addObserver(self)

        syncStorage()
        firebaseFirestoreMedicineCheckerController.updateData(for: user?.id ?? "")
    }

    override func stop() {
        firebaseFirestoreMedicineCheckerController.removeObserver(self)

        super.stop()
    }

    func showMedicineItemInfoScreen(with id: String) {
        checkIfRouterSet()

        router?.attachItemInfoRouter(with: id)
    }

    func showBarcodeScannerScreen() {
        checkIfRouterSet()

        router?.attachBarcodeCaptureRouter()
    }

    func updateDisplyingMedicineItems(filteredBy date: Date?) {
        presenter?.updateView(rawData: medicineItems, filteredBy: date)
    }

    // MARK: - Private Methods

    private func syncStorage() {
        user = UserEntityWrapper(coreDataAssistant: coreDataAssistant)
        medicineItems = loadMedicineItems(from: user?.medicineItems)

        updateView()
    }

    private func updateView() {
        presenter?.updateView(rawData: medicineItems, filteredBy: Date())
    }

    private func loadMedicineItems(from rawData: NSMutableArray?) -> [MedicineItemCompositeWrapper] {
        guard let rawData = rawData else {
            logWarning(message: "Failed to load medicine items")
            return []
        }

        let medicineItems: [MedicineItemCompositeWrapper] = rawData.compactMap {
            guard let rawPeriod = $0 as? NSManagedObject else {
                return nil
            }

            let medicineItem = MedicineItemEntityWrapper(entityObject: rawPeriod, coreDataAssistant: coreDataAssistant)
            let periods = loadPeriods(from: medicineItem.periods)

            return .init(wrappers: medicineItem, periods)
        }

        return medicineItems
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

// MARK: - Protocol FirebaseFirestoreMedicineCheckerDelegate

extension MedicineListInteractorImpl: FirebaseFirestoreMedicineCheckerDelegate {

    func didFinishUpload(with error: Error?) {
        guard error == nil else {
            checkIfListenerSet()

            listener?.didObtainError(error!)
            return
        }

        firebaseFirestoreMedicineCheckerController.updateData(for: user?.id ?? "")
    }

    func didFinishStorageUpdate(with error: Error?) {
        guard error == nil else {
            checkIfListenerSet()
            
            listener?.didObtainError(error!)
            return
        }

        syncStorage()
    }

}

// MARK: - Protocol FirebaseFirestoreMedicineCheckerDelegate

extension MedicineListInteractorImpl: MedicineItemInfoListener {

    func closeScreen() {
        checkIfRouterSet()

        router?.detachItemInfoRouter()
    }

}

// MARK: - Protocol BarcodeCaptureListener

extension MedicineListInteractorImpl: BarcodeCaptureListener {

    func cancel() {
        checkIfRouterSet()

        router?.detachBarcodeCaptureRouter()
    }

}
