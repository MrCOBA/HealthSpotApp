import UIKit
import CaBUIKit
import CaBRiblets
import CaBFoundation
import CaBMedicineChecker

// MARK: - Protocol

protocol MainRouter: ViewableRouter {

    func attachHomeRouter()
    func attachMedicineControllerRouter()
    func attachFoodControllerRouter()
    func attachSettingsRouter()

}

// MARK: - Implementation

final class MainRouterImpl: BaseRouter, MainRouter {

    // MARK: - Internal Properties

    var view: UIViewController {
        return containerViewController
    }

    // MARK: - Private Properties

    private let interactor: MainInteractor

    private let rootServices: RootServices
    private var containerViewController: CaBTabBarController

    private var homeRouter: ViewableRouter?
    private var medicineControllerRouter: ViewableRouter?
    private var foodControllerRouter: ViewableRouter?
    private var settingsRouter: ViewableRouter?

    // MARK: - Init

    init(rootServices: RootServices, view: CaBTabBarController, interactor: MainInteractor) {
        self.rootServices = rootServices
        self.containerViewController = view
        self.interactor = interactor

        super.init(interactor: interactor)
    }

    // MARK: - Internal Methods

    func attachHomeRouter() {
        guard homeRouter == nil else {
            return
        }

        let router = HomeContainerBuilder(factory: rootServices, listener: interactor).build()
        router.start()

        homeRouter = router
        showItemRouter(.home, router: router)
    }

    func attachMedicineControllerRouter() {
        guard medicineControllerRouter == nil else {
            return
        }

        let router = MedicineCheckerContainerBuilder(factory: rootServices, listener: interactor).build()
        router.start()

        medicineControllerRouter = router
        showItemRouter(.medicineChecker, router: router)
    }

    func attachFoodControllerRouter() {
        guard foodControllerRouter == nil else {
            return
        }
        // TODO: Implement screen attaching
    }

    func attachSettingsRouter() {
        guard settingsRouter == nil else {
            return
        }
        // TODO: Implement screen attaching
    }

    // MARK: - Private Methods

    private func showItemRouter(_ item: MainView.Item, router: ViewableRouter?) {
        guard let router = router else {
            logError(message: "Router expected to be provided")
            return
        }

        containerViewController.setController(router.view, to: item)
    }

}
