import CaBRiblets
import CaBSDK

// MARK: - Implementation

protocol MainInteractor: Interactor {

    func showHomeScreen()
    func showMedicineControllerScreen()
    func showFoodControllerScreen()
    func showSettingsScreen()

}

final class MainInteractorImpl: BaseInteractor, MainInteractor {

    weak var router: MainRouter?

    var presenter: MainPresenter?

    override func start() {
        super.start()

        guard presenter != nil else {
            logError(message: "Presenter expected to be set")
            return
        }
        presenter?.updateView(with: [.home, .medicineController, .foodController, .settings])
    }

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

    private func checkIfRouterSet() {
        guard router != nil else {
            logError(message: "Router expected to be set")
            return
        }
    }

}

extension MainInteractorImpl: MainViewEventsHandler {

    func didSelectTab(with child: MainView.Item) {
        checkIfRouterSet()

        switch child {
        case .home:
            router?.attachHomeRouter()

        case .medicineController:
            router?.attachMedicineControllerRouter()

        case .foodController:
            router?.attachFoodControllerRouter()

        case .settings:
            router?.attachSettingsRouter()

        default:
            logError(message: "Unknown item recieved with identifier: <\(child.rawValue)>")
        }
    }

}
