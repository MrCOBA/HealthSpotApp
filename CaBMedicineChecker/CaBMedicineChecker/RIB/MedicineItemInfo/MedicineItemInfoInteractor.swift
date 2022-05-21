import CoreData
import CaBRiblets
import CaBSDK

protocol MedicineItemInfoInteractor: Interactor, MedicineItemPeriodListener {

}

final class MedicineItemInfoInteractorImpl: BaseInteractor, MedicineItemInfoInteractor {

    weak var router: MedicineItemInfoRouter?
    var presenter: MedicineItemInfoPresenter?

    private let coreDataAssistant: CoreDataAssistant

    private let entityId: String
    private var medicineItem: MedicineItemEntityWrapper?
    private var periods = [MedicineItemPeriodEntityWrapper]()

    init(coreDataAssistant: CoreDataAssistant, entityId: String) {
        self.entityId = entityId
        self.coreDataAssistant = coreDataAssistant
    }

    override func start() {
        super.start()

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

}

extension MedicineItemInfoInteractorImpl: MedicineItemPeriodListener {

    func savePeriod() {

    }

    func cancel() {
        checkIfRouterSet()

        router?.detachItemPeriodView(isPopNeeded: false)
    }

}
