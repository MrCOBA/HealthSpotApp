import CoreData
import CaBRiblets
import CaBSDK

protocol MedicineListInteractor: Interactor {

}

final class MedicineListInteractorImpl: BaseInteractor, MedicineListInteractor {

    typealias MedicineItemCompositeWrapper = CompositeWrapper<MedicineItemEntityWrapper, MedicineItemPeriodEntityWrapper>

    weak var router: MedicineListRouter?
    var presenter: MedicineListPresenter?

    private let coreDataAssistant: CoreDataAssistant
    private var user: UserEntityWrapper?
    private var medicineItems = [MedicineItemCompositeWrapper]()

    init(coreDataAssistant: CoreDataAssistant) {
        self.coreDataAssistant = coreDataAssistant
    }

    override func start() {
        super.start()

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
