import CaBRiblets
import CaBFoundation
import CaBMedicineChecker

// MARK: - Protocol

protocol MainInteractor: Interactor,
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

        presenter?.updateView(with: [.home, .medicineChecker, .settings])
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

extension MainInteractorImpl: HomeContainerListener { }
