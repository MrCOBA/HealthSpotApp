import CaBRiblets
import CaBSDK
import CaBAuthorization

protocol HealthSpotRootInteractor: Interactor,
                                   AuthorizationContainerListener {

}

final class HealthSpotRootInteractorImpl: BaseInteractor, HealthSpotRootInteractor {

    weak var router: HealthSpotRootRouter?

    private func checkIfRouterSet() {
        guard router != nil else {
            logError(message: "Router expected to be set")
            return
        }
    }

}

extension HealthSpotRootInteractorImpl: AuthorizationContainerListener {

    func completeAuthorization() {
        checkIfRouterSet()
        router?.attachMainFlow()
    }

}
