import CaBRiblets
import CaBFoundation
import CaBMedicineChecker

// MARK: - Protocol

protocol MainInteractor: Interactor,
                         MedicineCheckerContainerListener {

    func showHomeScreen()
    func showMedicineControllerScreen()
    func showFoodControllerScreen()
    func showSettingsScreen()

}

// MARK: - Implementation

final class MainInteractorImpl: BaseInteractor, MainInteractor {

    // MARK: - Internal Properties

    weak var router: MainRouter?

    var presenter: MainPresenter?

    // MARK: - Internal Methods

    // MARK: Overrides

    override func start() {
        super.start()

        guard presenter != nil else {
            logError(message: "Presenter expected to be set")
            return
        }
        presenter?.updateView(with: [.home, .medicineController, .foodController, .settings])
    }

    // MARK: Protocol MainInteractor

    func showHomeScreen() {
        checkIfRouterSet()
        router?.attachHomeRouter()
    }

    func showMedicineControllerScreen() {
        checkIfRouterSet()
        router?.attachMedicineControllerRouter()
    }

    func showFoodControllerScreen() {
        checkIfRouterSet()
        router?.attachFoodControllerRouter()
    }

    func showSettingsScreen() {
        checkIfRouterSet()
        router?.attachSettingsRouter()
    }

    // MARK: - Private Methods

    private func checkIfRouterSet() {
        guard router != nil else {
            logError(message: "Router expected to be set")
            return
        }
    }

}

extension MainInteractorImpl: MedicineCheckerContainerListener {
    
}
