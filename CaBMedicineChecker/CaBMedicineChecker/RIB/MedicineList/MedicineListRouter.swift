import CaBRiblets
import CaBFoundation
import UIKit

protocol MedicineListRouter: ViewableRouter {

    func attachItemInfoRouter(with id: String)
    func detachItemInfoRouter(isPopNeeded: Bool)

    func attachBarcodeCaptureRouter()
    func detachBarcodeCaptureRouter(isDismissNeeded: Bool)

}

final class MedicineListRouterImpl: BaseRouter, MedicineListRouter {

    var view: UIViewController

    private let interactor: MedicineListInteractor
    private let rootServices: MedicineCheckerRootServices
    private var currentChild: ViewableRouter?

    init(rootServices: MedicineCheckerRootServices, view: MedicineListView, interactor: MedicineListInteractor) {
        self.interactor = interactor
        self.rootServices = rootServices
        self.view = view

        super.init(interactor: interactor)
    }

    func attachItemInfoRouter(with id: String) {
        let router = MedicineItemInfoBuilder(factory: rootServices, listener: interactor).build(with: id)

        attachChildWithPush(router)
    }

    func detachItemInfoRouter(isPopNeeded: Bool) {
        detachChildWithPop(isPopNeeded: isPopNeeded)
    }

    func attachBarcodeCaptureRouter() {
        let router = BarcodeCaptureBuilder(factory: rootServices, listener: interactor).build()

        attachChildWithPresent(router)
    }

    func detachBarcodeCaptureRouter(isDismissNeeded: Bool) {
        detachChildWithDismiss(isDismissNeeded: isDismissNeeded)
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
