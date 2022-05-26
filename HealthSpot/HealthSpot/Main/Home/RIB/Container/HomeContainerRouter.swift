import CaBRiblets
import CaBUIKit
import CaBFoundation
import UIKit

protocol HomeContainerRouter: ViewableRouter {

    func attachHomeRouter()

}

final class HomeContainerRouterImpl: BaseRouter, HomeContainerRouter {

    // MARK: - Internal Properties

    var view: UIViewController {
        return containerViewController
    }

    // MARK: - Private Properties

    private var containerViewController: CaBNavigationController
    private let rootServices: RootServices
    private let interactor: HomeContainerInteractor

    private var rootChild: ViewableRouter?

    // MARK: - Init

    init(rootServices: RootServices, view: CaBNavigationController, interactor: HomeContainerInteractor) {
        self.rootServices = rootServices
        self.containerViewController = view
        self.interactor = interactor

        super.init(interactor: interactor)
    }

    // MARK: - Internal Methods

    override func start() {
        super.start()

        attachHomeRouter()
    }

    func attachHomeRouter() {
        let router = HomeBuilder(factory: rootServices).build()

        attachChildWithEmbed(router)
    }

    // MARK: - Private Methods

    private func attachChildWithEmbed(_ child: ViewableRouter) {
        if rootChild != nil {
            rootChild?.stop()
        }

        rootChild = child
        rootChild?.start()
        containerViewController.embedIn(child.view, animated: true)
    }

}
