import CoreData
import CaBRiblets
import CaBSDK

protocol MedicineItemInfoInteractor: Interactor, MedicineItemPeriodListener {

}

final class MedicineItemInfoInteractorImpl: BaseInteractor {

    weak var router: MedicineItemInfoRouter?

    private let coreDataAssistant: CoreDataAssistant

    private let entityId: Int16
    private var medicineItem: MedicineItemEntityWrapper?
    private var periods = [MedicineItemPeriodEntityWrapper]()

    init(coreDataAssistant: CoreDataAssistant, entityId: Int16) {
        self.entityId = entityId
        self.coreDataAssistant = coreDataAssistant
        self.periods = []
    }

    override func start() {
        super.start()

        medicineItem = loadEntity(with: entityId)
        periods = loadPeriods(from: medicineItem?.periods)
    }

    private func loadEntity(with id: Int16) -> MedicineItemEntityWrapper? {
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
