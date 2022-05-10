import UIKit
import CaBUIKit
import CaBRiblets
import CaBSDK

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

    var view: UIViewController

    // MARK: - Private Properties

    private var homeRouter: ViewableRouter?
    private var medicineControllerRouter: ViewableRouter?
    private var foodControllerRouter: ViewableRouter?
    private var settingsRouter: ViewableRouter?

    // MARK: - Init

    init(view: CaBTabBarController, interactor: MainInteractor) {
        self.view = view

        super.init(interactor: interactor)
    }

    // MARK: - Internal Methods

    func attachHomeRouter() {
        guard homeRouter == nil else {
            return
        }
        // TODO: Implement screen attaching
    }

    func attachMedicineControllerRouter() {
        guard medicineControllerRouter == nil else {
            return
        }
        // TODO: Implement screen attaching
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
        guard let view = view as? CaBTabBarController else {
            logError(message: "View expected to be of type CaBTabBarController")
            return
        }

        guard let router = router else {
            logError(message: "Router expected to be provided")
            return
        }

        view.setController(router.view, to: item)
    }

}
