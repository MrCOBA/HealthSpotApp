import CoreData
import CaBRiblets
import CaBSDK
import CaBFirebaseKit

protocol MedicineListInteractor: Interactor, MedicineItemInfoListener, BarcodeCaptureListener {

    func showMedicineItemInfoScreen(with id: String)
    func showBarcodeScannerScreen()

}

final class MedicineListInteractorImpl: BaseInteractor, MedicineListInteractor {

    typealias MedicineItemCompositeWrapper = CompositeWrapper<MedicineItemEntityWrapper, MedicineItemPeriodEntityWrapper>

    weak var router: MedicineListRouter?
    var presenter: MedicineListPresenter?

    private let coreDataAssistant: CoreDataAssistant
    private let firebaseFirestoreMedicineCheckerController: FirebaseFirestoreMedicineCheckerController
    private var user: UserEntityWrapper?
    private var medicineItems = [MedicineItemCompositeWrapper]()

    init(coreDataAssistant: CoreDataAssistant,
         presenter: MedicineListPresenter,
         firebaseFirestoreMedicineCheckerController: FirebaseFirestoreMedicineCheckerController) {
        self.coreDataAssistant = coreDataAssistant
        self.presenter = presenter
        self.firebaseFirestoreMedicineCheckerController = firebaseFirestoreMedicineCheckerController
    }

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

    private func syncStorage() {
        user = UserEntityWrapper(coreDataAssistant: coreDataAssistant)
        medicineItems = loadMedicineItems(from: user?.medicineItems)

        updateView()
    }

    private func updateView() {
        presenter?.updateView(rawData: medicineItems)
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

}

// MARK: - Protocol FirebaseFirestoreMedicineCheckerDelegate

extension MedicineListInteractorImpl: FirebaseFirestoreMedicineCheckerDelegate {

    func didFinishUpload(with error: Error?) {
        guard error == nil else {
            return
        }

        firebaseFirestoreMedicineCheckerController.updateData(for: user?.id ?? "")
    }

    func didFinishStorageUpdate(with error: Error?) {
        guard error == nil else {
            return
        }

        syncStorage()
    }

}

// MARK: - Protocol FirebaseFirestoreMedicineCheckerDelegate

extension MedicineListInteractorImpl: MedicineItemInfoListener {

    func closeScreen() {
        checkIfRouterSet()

        router?.detachItemInfoRouter(isPopNeeded: true)
    }

}

extension MedicineListInteractorImpl: BarcodeCaptureListener {

    func cancel() {
        checkIfRouterSet()

        router?.detachBarcodeCaptureRouter(isDismissNeeded: true)
    }

}
