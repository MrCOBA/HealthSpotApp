import CaBRiblets
import CaBSDK

protocol MainInteractor: Interactor {

}

final class MainInteractorImpl: BaseInteractor, MainInteractor {

    weak var router: MainRouter?

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
