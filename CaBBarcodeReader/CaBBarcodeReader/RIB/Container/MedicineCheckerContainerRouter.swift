import CaBRiblets
import CaBUIKit
import CaBSDK
import UIKit

public protocol MedicineCheckerContainerRouter: ViewableRouter {

}

final class MedicineCheckerContainerRouterImpl: BaseRouter, MedicineCheckerContainerRouter {

    // MARK: - Internal Properties

    var view: UIViewController {
        return containerViewController
    }

    // MARK: - Private Properties

    private var containerViewController: CaBNavigationController

    private let interactor: MedicineCheckerContainerInteractor

    private var rootChild: ViewableRouter?

    // MARK: - Init

    init(view: CaBNavigationController, interactor: MedicineCheckerContainerInteractor) {
        self.containerViewController = view
        self.interactor = interactor

        super.init(interactor: interactor)
    }

    override func start() {
        super.start()
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
