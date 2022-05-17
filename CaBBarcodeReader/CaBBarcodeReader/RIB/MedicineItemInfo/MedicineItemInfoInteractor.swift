import CoreData
import CaBRiblets
import CaBSDK

protocol MedicineItemInfoInteractor: Interactor {

}

final class MedicineItemInfoInteractorImpl: BaseInteractor {

    weak var router: MedicineItemInfoRouter?

    private let coreDataAssistant: CoreDataAssistant
    private var entityObject: NSManagedObject?

    init(coreDataAssistant: CoreDataAssistant, entityId: Int16) {
        self.coreDataAssistant = coreDataAssistant
    }

    private func loadEntity() {
        entityObject = coreDataAssistant.createEntity(NSManagedObject.EntityName.medicineItem)
    }

    private func performEntity() {
        guard let id = entityObject?.value(forKey: "id") as? Int16 else {
            logError(message: "Failed to fetch <id> field")
            return
        }

        guard let barcode = entityObject?.value(forKey: "barcode") as? String else {
            logError(message: "Failed to fetch <barcode> field")
            return
        }

        guard let marketPath = entityObject?.value(forKey: "marketUrl") as? String else {
            logError(message: "Failed to fetch <id> field")
            return
        }

        guard let name = entityObject?.value(forKey: "name") as? String else {
            logError(message: "Failed to fetch <name> field")
            return
        }

        let imagePath = entityObject?.value(forKey: "imageUrl") as? String

        guard let producer = entityObject?.value(forKey: "producer") as? String else {
            logError(message: "Failed to fetch <producer> field")
            return
        }

        let activeComponent = entityObject?.value(forKey: "activeComponent") as? String
        
    }

    private func performEntities(from set: NSSet) {

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
