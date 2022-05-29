import CaBRiblets
import CaBFoundation
import UIKit

// MARK: - Protocol

protocol MedicineListRouter: ViewableRouter {

    func attachItemInfoRouter(with id: String)
    func detachItemInfoRouter()

    func attachBarcodeCaptureRouter()
    func detachBarcodeCaptureRouter()

}

// MARK: - Implementation

final class MedicineListRouterImpl: BaseRouter, MedicineListRouter {

    // MARK: - Internal Properties

    var view: UIViewController

    // MARK: - Private Properties

    private let interactor: MedicineListInteractor
    private let rootServices: MedicineCheckerRootServices
    private var currentChild: ViewableRouter?

    // MARK: - Init

    init(rootServices: MedicineCheckerRootServices, view: MedicineListView, interactor: MedicineListInteractor) {
        self.interactor = interactor
        self.rootServices = rootServices
        self.view = view

        super.init(interactor: interactor)
    }

    // MARK: - Internal Methods

    func attachItemInfoRouter(with id: String) {
        let router = MedicineItemInfoBuilder(factory: rootServices, listener: interactor).build(with: id)

        attachChildWithPush(router)
    }

    func detachItemInfoRouter() {
        detachChildWithPop()
    }

    func attachBarcodeCaptureRouter() {
        let router = BarcodeCaptureBuilder(factory: rootServices, listener: interactor).build()

        attachChildWithPresent(router)
    }

    func detachBarcodeCaptureRouter() {
        detachChildWithDismiss()
    }

    // MARK: - Private Methods
    
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

    private func attachChildWithPresent(_ child: ViewableRouter) {
        guard currentChild == nil else {
            logWarning(message: "Child router has already atttached")
            return
        }

        attachChild(child)
        view.tabBarController?.present(child.view, animated: true)
        currentChild = child
    }

    private func detachChildWithDismiss() {
        guard let currentChild = currentChild else {
            logWarning(message: "There is no same child to detach")
            return
        }

        detachChild(currentChild)
        view.tabBarController?.dismiss(animated: true)
        self.currentChild = nil
    }
    
}
