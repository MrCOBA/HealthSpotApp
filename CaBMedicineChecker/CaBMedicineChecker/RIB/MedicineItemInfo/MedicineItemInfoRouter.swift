import UIKit
import CaBFoundation
import CaBRiblets

protocol MedicineItemInfoRouter: ViewableRouter {

    func attachItemPeriodRouter(with actionType: MedicineItemPeriodActionType)
    func detachItemPeriodRouter(isPopNeeded: Bool)

}

final class MedicineItemInfoRouterImpl: BaseRouter, MedicineItemInfoRouter {

    var view: UIViewController

    private let interactor: MedicineItemInfoInteractor
    private let rootServices: MedicineCheckerRootServices
    private var currentChild: ViewableRouter?

    init(rootServices: MedicineCheckerRootServices, view: MedicineItemInfoView, interactor: MedicineItemInfoInteractor) {
        self.interactor = interactor
        self.rootServices = rootServices
        self.view = view

        super.init(interactor: interactor)
    }

    func attachItemPeriodRouter(with actionType: MedicineItemPeriodActionType) {
        let router = MedicineItemPeriodBuilder(factory: rootServices, listener: interactor).build(with: actionType)

        attachChildWithPush(router)
    }

    func detachItemPeriodRouter(isPopNeeded: Bool) {
        detachChildWithPop(isPopNeeded: isPopNeeded)
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

}
