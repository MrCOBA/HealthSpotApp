import CaBRiblets
import CaBSDK

protocol MedicineItemInfoInteractor: Interactor {

}

final class MedicineItemInfoInteractorImpl: BaseInteractor {

    weak var router: MedicineItemInfoRouter?

    private let coreDataAssistant: CoreDataAssistant

    init(coreDataAssistant: CoreDataAssistant) {
        self.coreDataAssistant = coreDataAssistant
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
