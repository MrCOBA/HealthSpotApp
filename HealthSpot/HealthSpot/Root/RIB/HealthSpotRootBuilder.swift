import CaBRiblets
import CaBUIKit
import UIKit

final class HealthSpotRootBuilder: Builder {

    func build() -> ViewableRouter {
        let view = UITabBarController()
        view.tabBar.isHidden = true

        let interactor = HealthSpotRootInteractorImpl()
        let router = HealthSpotRootRouterImpl(view: view, interactor: interactor)

        return router
    }

}
