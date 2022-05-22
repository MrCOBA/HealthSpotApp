import CaBRiblets
import CaBFirebaseKit
import CaBSDK

protocol BarcodeCaptureListener: AnyObject {

    func cancel()

}

final class BarcodeCaptureInteractor: BaseInteractor {

    weak var listener: BarcodeCaptureListener?

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

        firebaseFirestoreMedicineCheckerController.addObserver(self)
    }

    override func stop() {
        firebaseFirestoreMedicineCheckerController.removeObserver(self)

        super.stop()
    }

    private func checkIfListenerSet() {
        if listener == nil {
            logError(message: "Listener expected to be set")
        }
    }

    private func addMedicineItem(with barcode: String) {
        user = UserEntityWrapper(coreDataAssistant: coreDataAssistant)
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
        /* Do Nothing */
    }

    func didFinishUpload(with error: Error?) {
        didCaptureCancel()
    }

}
