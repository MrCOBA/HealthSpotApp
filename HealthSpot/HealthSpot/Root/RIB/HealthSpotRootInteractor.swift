import CaBRiblets
import CaBSDK
import CaBAuthorization

protocol HealthSpotRootInteractor: Interactor,
                                   AuthorizationContainerListener {

}

final class HealthSpotRootInteractorImpl: BaseInteractor, HealthSpotRootInteractor {

}

extension HealthSpotRootInteractorImpl: AuthorizationContainerListener {

    func completeAuthorization() {
        // TODO: Add move to the main screen
    }

}
