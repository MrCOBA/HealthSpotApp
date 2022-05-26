import CaBRiblets
import CaBFoundation
import CaBMedicineChecker

// MARK: - Protocol

protocol MainInteractor: Interactor,
                         MedicineCheckerContainerListener,
                         HomeContainerListener {

    func showItem(_ item: MainView.Item)

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
        presenter?.updateView(with: [.home, .medicineChecker, .foodController, .settings])
    }

    // MARK: Protocol MainInteractor

    func showItem(_ item: MainView.Item) {
        checkIfRouterSet()
        router?.attachItem(item)
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

extension MainInteractorImpl: HomeContainerListener {
    
}
