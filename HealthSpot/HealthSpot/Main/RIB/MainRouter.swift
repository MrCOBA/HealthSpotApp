import UIKit
import CaBUIKit
import CaBRiblets
import CaBFoundation
import CaBMedicineChecker

// MARK: - Protocol

protocol MainRouter: ViewableRouter {

    func attachItem(_ item: MainView.Item)

}

// MARK: - Implementation

final class MainRouterImpl: BaseRouter, MainRouter {

    // MARK: - Internal Properties

    var view: UIViewController {
        return containerViewController
    }

    // MARK: - Private Properties

    private let root: MainView.Item

    private let interactor: MainInteractor

    private let rootServices: RootServices
    private var containerViewController: CaBTabBarController

    private var homeRouter: ViewableRouter?
    private var medicineControllerRouter: ViewableRouter?
    private var foodControllerRouter: ViewableRouter?
    private var settingsRouter: ViewableRouter?

    // MARK: - Init

    init(_ root: MainView.Item, rootServices: RootServices, view: CaBTabBarController, interactor: MainInteractor) {
        self.root = root
        self.rootServices = rootServices
        self.containerViewController = view
        self.interactor = interactor

        super.init(interactor: interactor)
    }

    // MARK: - Internal Methods

    override func start() {
        super.start()

        attachItem(root)
    }

    func attachItem(_ item: MainView.Item) {
        switch item {
        case .home:
            attachHomeRouter()

        case .medicineChecker:
            attachMedicineCheckerRouter()

        case .foodController:
            attachFoodControllerRouter()

        case .settings:
            attachSettingsRouter()

        default:
            logError(message: "Unknown item recieved with identifier: <\(item.rawValue)>")
        }
    }

    // MARK: - Private Methods
    
    private func attachHomeRouter() {
        guard homeRouter == nil else {
            return
        }

        let router = HomeContainerBuilder(factory: rootServices, listener: interactor).build()
        router.start()

        homeRouter = router
        showItemRouter(.home, router: router)
    }

    private func attachMedicineCheckerRouter() {
        guard medicineControllerRouter == nil else {
            return
        }

        let router = MedicineCheckerContainerBuilder(factory: rootServices).build()
        router.start()

        medicineControllerRouter = router
        showItemRouter(.medicineChecker, router: router)
    }

    private func attachFoodControllerRouter() {
        guard foodControllerRouter == nil else {
            return
        }
        // TODO: Implement screen attaching
    }

    private func attachSettingsRouter() {
        guard settingsRouter == nil else {
            return
        }
        // TODO: Implement screen attaching
    }

    private func showItemRouter(_ item: MainView.Item, router: ViewableRouter?) {
        guard let router = router else {
            logError(message: "Router expected to be provided")
            return
        }

        containerViewController.setController(router.view, to: item)
    }

}
