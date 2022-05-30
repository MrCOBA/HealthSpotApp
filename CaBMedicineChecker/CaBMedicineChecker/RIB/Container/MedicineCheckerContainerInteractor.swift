import CaBRiblets
import CaBFoundation

protocol MedicineCheckerContainerInteractor: Interactor, MedicineListListener { }

public final class MedicineCheckerContainerInteractorImpl: BaseInteractor, MedicineCheckerContainerInteractor {

    // MARK: - Internal Properties

    weak var router: MedicineCheckerContainerRouter?

    // MARK: - Private Methods

    private func checkIfRouterSet() {
        guard router != nil else {
            logError(message: "Router expected to be set")
            return
        }
    }

}

extension MedicineCheckerContainerInteractorImpl: MedicineListListener {

    func didObtainError(_ error: Error) {
        checkIfRouterSet()

        router?.attachAlert(with: error)
    }

}
