import CaBRiblets
import CaBFoundation

enum MedicineItemPeriodActionType: Equatable {

    case add
    case edit(id: String)
    case delete(id: String)

}

// MARK: - Listener

protocol MedicineItemPeriodListener: AnyObject {

    func updatePeriod(with actionType: MedicineItemPeriodActionType)
    func closeItemPeriodEditorScreen()

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
        case frequency
        case notificationHint
    }

    // MARK: - Internal Properties

    weak var listener: MedicineItemPeriodListener?

    // MARK: - Private Properties

    private let coreDataAssistant: CoreDataAssistant
    private let storage: MedicineItemPeriodTemporaryStorage
    private var presenter: MedicineItemPeriodPresenter?
    private let actionType: MedicineItemPeriodActionType

    // MARK: - Init

    init(coreDataAssistant: CoreDataAssistant,
         actionType: MedicineItemPeriodActionType,
         storage: MedicineItemPeriodTemporaryStorage,
         presenter: MedicineItemPeriodPresenter,
         listener: MedicineItemPeriodListener?) {
        self.coreDataAssistant = coreDataAssistant
        self.actionType = actionType
        self.storage = storage
        self.presenter = presenter
        self.listener = listener
    }

    // MARK: - Internal Methods

    override func start() {
        super.start()

        switch actionType {
        case .add:
            break

        case .edit(let id), .delete(let id):
            loadEntity(with: id)
        }

        presenter?.updateView(for: actionType)
    }

    func updateStorage(_ field: MedicineItemPeriodInteractorImpl.UpdateField, with data: Any?) {
        switch field {
        case .startDate:
            storage.startDate = (data as? Date) ?? Date()

        case .endDate:
            storage.endDate = (data as? Date)

        case .notificationHint:
            storage.notificationHint = (data as? String) ?? ""

        case .frequency:
            storage.frequency = (data as? String)
        }

        presenter?.updateView(for: actionType)
    }

    func updatePeriod() {
        checkIfListenerSet()

        listener?.updatePeriod(with: actionType)
    }

    func cancelUpdatePeriod() {
        checkIfListenerSet()

        storage.clear()
        listener?.closeItemPeriodEditorScreen()
    }

    // MARK: - Private Methods

    private func loadEntity(with id: String) {
        if let periodWrapper = MedicineItemPeriodEntityWrapper(id: id, coreDataAssistant: coreDataAssistant) {
            storage.id = periodWrapper.id
            storage.startDate = periodWrapper.startDate
            storage.endDate = periodWrapper.endDate
            storage.frequency = periodWrapper.frequency
            storage.notificationHint = periodWrapper.notificationHint
        }
        else {
            storage.clear()
        }
    }

    private func checkIfListenerSet() {
        if listener == nil {
            logError(message: "Listener expected to be set")
        }
    }

}
