import UIKit
import CaBFoundation
import CaBRiblets

// MARK: - Protocol

protocol MedicineItemInfoRouter: ViewableRouter {

    func attachItemPeriodRouter(with actionType: MedicineItemPeriodActionType)
    func detachItemPeriodRouter()

}

// MARK: - Implementation

final class MedicineItemInfoRouterImpl: BaseRouter, MedicineItemInfoRouter {

    // MARK: - Internal Properties

    var view: UIViewController

    // MARK: - Private Properties

    private let interactor: MedicineItemInfoInteractor
    private let rootServices: MedicineCheckerRootServices
    private var currentChild: ViewableRouter?

    // MARK: - Init

    init(rootServices: MedicineCheckerRootServices, view: MedicineItemInfoView, interactor: MedicineItemInfoInteractor) {
        self.interactor = interactor
        self.rootServices = rootServices
        self.view = view

        super.init(interactor: interactor)
    }

    // MARK: - Internal Methods

    func attachItemPeriodRouter(with actionType: MedicineItemPeriodActionType) {
        let router = MedicineItemPeriodBuilder(factory: rootServices, listener: interactor).build(with: actionType)

        attachChildWithPush(router)
    }

    func detachItemPeriodRouter() {
        detachChildWithPop()
    }

    // MARK: - Privta Methods

    private func attachChildWithPush(_ child: ViewableRouter) {
        guard currentChild == nil else {
            logWarning(message: "Child router has already atttached")
            return
        }

        attachChild(child)
        view.navigationController?.pushViewController(child.view, animated: true)
        currentChild = child
    }

    private func detachChildWithPop() {
        guard let currentChild = currentChild else {
            logWarning(message: "There is no same child to detach")
            return
        }

        detachChild(currentChild)
        view.navigationController?.popViewController(animated: true)
        self.currentChild = nil
    }

}
