import CaBRiblets
import CaBUIKit
import UIKit

final class HealthSpotRootBuilder: Builder {

    // MARK: - Private Properties

    private let rootServices: RootServices

    // MARK: - Init

    init(rootServices: RootServices) {
        self.rootServices = rootServices
    }

    // MARK: - Internal Methods
    
    func build() -> ViewableRouter {
        let view = BaseContainerViewController()

        let interactor = HealthSpotRootInteractorImpl(authorizationManager: rootServices.authorizationManager,
                                                      coreDataAssistant: rootServices.coreDataAssistant,
                                                      rootSettingsStorage: rootServices.rootSettingsStorage)
        let router = HealthSpotRootRouterImpl(rootServices: rootServices, view: view, interactor: interactor)
        interactor.router = router

        return router
    }

}
