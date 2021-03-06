import CaBRiblets
import CaBFirebaseKit
import CaBFoundation

protocol BarcodeCaptureListener: AnyObject {

    func cancel()

}

final class BarcodeCaptureInteractor: BaseInteractor {

    weak var listener: BarcodeCaptureListener?
    weak var router: BarcodeCaptureRouter?

    private let coreDataAssistant: CoreDataAssistant
    private let firebaseFirestoreMedicineCheckerController: FirebaseFirestoreMedicineCheckerController
    private var user: UserEntityWrapper?

    init(coreDataAssistant: CoreDataAssistant,
         firebaseFirestoreMedicineCheckerController: FirebaseFirestoreMedicineCheckerController,
         listener: BarcodeCaptureListener?) {
        self.coreDataAssistant = coreDataAssistant
        self.firebaseFirestoreMedicineCheckerController = firebaseFirestoreMedicineCheckerController
        self.listener = listener
    }

    override func start() {
        super.start()

        firebaseFirestoreMedicineCheckerController.add(observer: self)
    }

    override func stop() {
        firebaseFirestoreMedicineCheckerController.remove(observer: self)

        super.stop()
    }

    private func checkIfListenerSet() {
        if listener == nil {
            logError(message: "Listener expected to be set")
        }
    }

    private func checkIfRouterSet() {
        if router == nil {
            logError(message: "Router expected to be set")
        }
    }

    private func addMedicineItem(with barcode: String) {
        user = UserEntityWrapper(coreDataAssistant: coreDataAssistant)

        let predicate = NSPredicate(format: "barcode = %@", barcode)
        if coreDataAssistant.loadData("MedicineItem", predicate: predicate, sortDescriptor: nil)?.count ?? 0 != 0 {
            checkIfRouterSet()

            router?.attachAlert(with: FirebaseFirestoreMedicineCheckerError.itemAlreadyExists) { [weak self] _ in
                self?.didCaptureCancel()
            }
            return 
        }

        firebaseFirestoreMedicineCheckerController.addMedicineItem(with: barcode, to: user?.id ?? "")
    }

}

extension BarcodeCaptureInteractor: BarcodeCaptureEventsHandler {

    func didCaptureCancel() {
        checkIfListenerSet()

        listener?.cancel()
    }

    func handleReceivedBarcode(_ barcode: String) {
        addMedicineItem(with: barcode)
    }

}

extension BarcodeCaptureInteractor: FirebaseFirestoreMedicineCheckerDelegate {

    func didFinishStorageUpdate(with error: Error?) {
        checkIfRouterSet()
        guard let error = error else {
            return
        }

        router?.attachAlert(with: error) { [weak self] _ in
            self?.didCaptureCancel()
        }
    }

    func didFinishUpload(with error: Error?) {
        didCaptureCancel()
    }

}
