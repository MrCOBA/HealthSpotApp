import UIKit
import CaBRiblets
import CaBAuthorization
import CaBSDK

protocol HealthSpotRootRouter: ViewableRouter {

    func attachAuthorizationFlow()

}

final class HealthSpotRootRouterImpl: BaseRouter, HealthSpotRootRouter {

    // MARK: - Internal Properties

    var view: UIViewController {
        return containerViewController
    }

    // MARK: - Private Properties

    private var containerViewController: UITabBarController

    private let interactor: HealthSpotRootInteractor

    private var rootChild: Router?
    private weak var authorizationContainerRouter: ViewableRouter?

    init(view: UITabBarController, interactor: HealthSpotRootInteractor) {
        self.containerViewController = view
        self.interactor = interactor

        super.init(interactor: interactor)
    }

    override func start() {
        super.start()

        attachRoot()
    }

    func attachAuthorizationFlow() {
        guard authorizationContainerRouter == nil else {
            logError(message: "Authorization flow router already attached")
            return
        }

        let router = AuthorizationContainerBuilder(listener: interactor).build()
        attachChildWithEmbed(router)
        authorizationContainerRouter = router
    }

    // MARK: - Private Methods

    private func attachRoot() {
        // TODO: Implement another possible roots
        attachAuthorizationFlow()
    }

    private func attachChildWithEmbed(_ child: ViewableRouter) {
        if rootChild != nil {
            detachChild(child)
            rootChild = nil
        }

        attachChild(child)

        rootChild = child
        containerViewController.embedIn(child.view, animated: true)
    }
}
