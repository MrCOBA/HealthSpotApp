import CaBRiblets
import CaBUIKit
import UIKit

final class HealthSpotRootBuilder: Builder {

    func build() -> ViewableRouter {
        let view = BaseContainerViewController()

        let interactor = HealthSpotRootInteractorImpl()
        let router = HealthSpotRootRouterImpl(view: view, interactor: interactor)
        interactor.router = router

        return router
    }

}
