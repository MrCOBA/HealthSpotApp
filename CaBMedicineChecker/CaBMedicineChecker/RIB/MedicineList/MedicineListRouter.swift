import CaBRiblets
import CaBSDK
import UIKit

protocol MedicineListRouter: ViewableRouter {

    func attachItemInfoView(with id: Int16)
    func detachItemInfoView(isPopNeeded: Bool)

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

    func attachItemInfoView(with id: Int16) {
        let router = MedicineItemInfoBuilder(factory: rootServices).build(with: id)

        attachChildWithPush(router)
    }

    func detachItemInfoView(isPopNeeded: Bool) {
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
