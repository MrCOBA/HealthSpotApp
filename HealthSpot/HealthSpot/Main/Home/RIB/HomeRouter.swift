import CaBRiblets
import CaBFoundation
import UIKit

protocol HomeRouter: ViewableRouter {

    func attachStatisticsRouter()
    func detachStatisticsRouter()

}

final class HomeRouterImpl: BaseRouter, HomeRouter {

    var view: UIViewController

    private let interactor: HomeInteractor
    private let rootServices: RootServices
    private var currentChild: ViewableRouter?

    private var statisticsRouter: Router?

    init(rootServices: RootServices, view: HomeView, interactor: HomeInteractor) {
        self.interactor = interactor
        self.rootServices = rootServices
        self.view = view

        super.init(interactor: interactor)
    }

    func attachStatisticsRouter() {
        let router = HealthActivityStatisticsTrackerBuilder(factory: rootServices).build()

        router.start()
        statisticsRouter = router
    }

    func detachStatisticsRouter() {
        guard let statisticsRouter = statisticsRouter else {
            logWarning(message: "There is no same child to detach")
            return
        }

        statisticsRouter.stop()
        self.statisticsRouter = nil
    }

    private func attachChildWithPush(_ child: ViewableRouter) {
        guard currentChild == nil else {
            logWarning(message: "Child router has already atttached")
            return
        }

        attachChild(child)
        view.navigationController?.pushViewController(child.view, animated: true)
        currentChild = child
    }

    private func detachChildWithPop(isPopNeeded: Bool) {
        guard let currentChild = currentChild else {
            logWarning(message: "There is no same child to detach")
            return
        }

        detachChild(currentChild)
        if isPopNeeded {
            view.navigationController?.popViewController(animated: true)
        }
        self.currentChild = nil
    }

    private func attachChildWithPresent(_ child: ViewableRouter) {
        guard currentChild == nil else {
            logWarning(message: "Child router has already atttached")
            return
        }

        attachChild(child)
        view.tabBarController?.present(child.view, animated: true)
        currentChild = child
    }

    private func detachChildWithDismiss(isDismissNeeded: Bool) {
        guard let currentChild = currentChild else {
            logWarning(message: "There is no same child to detach")
            return
        }

        detachChild(currentChild)
        if isDismissNeeded {
            view.tabBarController?.dismiss(animated: true)
        }
        self.currentChild = nil
    }
    
}
