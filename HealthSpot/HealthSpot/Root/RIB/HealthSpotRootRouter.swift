import UIKit
import CaBUIKit
import CaBRiblets
import CaBAuthorization
import CaBSDK

protocol HealthSpotRootRouter: ViewableRouter {

    func attachAuthorizationFlow()
    func attachMainFlow()

}

final class HealthSpotRootRouterImpl: BaseRouter, HealthSpotRootRouter {

    // MARK: - Internal Properties

    var view: UIViewController

    // MARK: - Private Properties

    private let rootServices: RootServices
    private let interactor: HealthSpotRootInteractor

    private var rootChild: Router?
    private weak var authorizationContainerRouter: ViewableRouter?
    private weak var mainContainerRouter: ViewableRouter?

    init(rootServices: RootServices, view: BaseContainerViewController, interactor: HealthSpotRootInteractor) {
        self.rootServices = rootServices
        self.view = view
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

        let router = AuthorizationContainerBuilder(factory: rootServices, listener: interactor).build()
        attachChildWithEmbed(router)
        authorizationContainerRouter = router
    }

    func attachMainFlow() {
        guard mainContainerRouter == nil else {
            logError(message: "Main flow router already attached")
            return
        }

        let router = MainBuilder().build()
        attachChildWithEmbed(router)
        mainContainerRouter = router
    }

    // MARK: - Private Methods

    private func attachRoot() {
        // TODO: Implement another possible roots
        attachAuthorizationFlow()
    }

    private func attachChildWithEmbed(_ child: ViewableRouter) {
        if rootChild != nil {
            detachChild(rootChild!)
        }

        attachChild(child)

        rootChild = child
        view.addChild(child.view)
    }

}
