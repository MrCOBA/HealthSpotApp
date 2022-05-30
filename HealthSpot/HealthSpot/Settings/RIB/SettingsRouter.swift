import CaBRiblets
import CaBFoundation
import UIKit

// MARK: - Protocol

protocol SettingsRouter: ViewableRouter {

}

// MARK: - Implementation

final class SettingsRouterImpl: BaseRouter, SettingsRouter {

    // MARK: - Internal Properties

    var view: UIViewController

    // MARK: - Private Properties

    private let interactor: SettingsInteractor
    private let rootServices: RootServices
    private var currentChild: ViewableRouter?

    // MARK: - Init

    init(rootServices: RootServices, view: SettingsView, interactor: SettingsInteractor) {
        self.interactor = interactor
        self.rootServices = rootServices
        self.view = view

        super.init(interactor: interactor)
    }

    // MARK: - Internal Methods


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
