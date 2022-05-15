import CaBRiblets
import CaBSDK

// MARK: - Listener

protocol MedicineItemPeriodListener: AnyObject {

    func savePeriod()
    func cancel()

}

// MARK: - Protocol

protocol MedicineItemPeriodInteractor: Interactor {

    func updateStorage(_ field: MedicineItemPeriodInteractorImpl.UpdateField, with data: Any?)
    func updatePeriod()
    func cancelUpdatePeriod()

}

// MARK: - Implementation

final class MedicineItemPeriodInteractorImpl: BaseInteractor, MedicineItemPeriodInteractor {

    // MARK: - Internal Types

    enum UpdateField {
        case startDate
        case endDate
        case repeatType
        case notificationHint
    }

    // MARK: - Internal Properties

    weak var listener: MedicineItemPeriodListener?

    // MARK: - Private Properties

    private let storage: MedicineItemPeriodTemporaryStorage
    private var presenter: MedicineItemPeriodPresenter?

    // MARK: - Init

    init(storage: MedicineItemPeriodTemporaryStorage, presenter: MedicineItemPeriodPresenter, listener: MedicineItemPeriodListener?) {
        self.storage = storage
        self.presenter = presenter
        self.listener = listener
    }

    // MARK: - Internal Methods

    override func start() {
        super.start()

        presenter?.updateView()
    }

    func updateStorage(_ field: MedicineItemPeriodInteractorImpl.UpdateField, with data: Any?) {
        switch field {
        case .startDate:
            storage.startDate = (data as? Date) ?? Date()

        case .endDate:
            storage.endDate = (data as? Date)

        case .notificationHint:
            storage.notificationHint = (data as? String) ?? ""

        case .repeatType:
            storage.repeatType = (data as? String)
        }

        presenter?.updateView()
    }

    func updatePeriod() {
        checkIfListenerSet()

        listener?.savePeriod()
    }

    func cancelUpdatePeriod() {
        checkIfListenerSet()

        storage.clear()
        listener?.cancel()
    }

    // MARK: - Private Methods

    private func checkIfListenerSet() {
        if listener == nil {
            logError(message: "Listener expected to be set")
        }
    }

}
