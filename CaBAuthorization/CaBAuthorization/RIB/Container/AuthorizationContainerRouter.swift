import CaBRiblets
import CaBUIKit
import UIKit

public enum AuthorizationResult {
    case success
    case failure(message: String?)
}

public protocol AuthorizationContainerRouter: ViewableRouter {
    func attachSignInScreen()
    func attachSignUpScreen()
    func attachInfoScreen(with result: AuthorizationResult)
}

final class AuthorizationContainerRouterImpl: AuthorizationContainerRouter, BaseRouter {

    // MARK: - Public Properties

    public var view: UINavigationController

    // MARK: - Private Properties

    private var currentChild: ViewableRouter?

    // MARK: - Init

    public init(view: UINavigationController, interactor: AuthorizationContainerInteractor) {
        self.view = view

        super.init(interactor: interactor)
    }

    // MARK: - Public Methods

    public func attachSignInScreen() {

    }

    public func attachSignUpScreen() {

    }

    public func attachInfoScreen(with result: AuthorizationResult) {

    }

    // MARK: - Private Methods

    private func attachChildWithPush(_ child: ViewableRouter) {
        if let currentChild = currentChild {
            detachChildWithDismiss(child)
            currentChild = nil
        }

        attachChild(child)

        currentChild = child
        view.pushViewController(child.view, animated: true)
    }

    private func attachChildWithEmbed(_ child: ViewableRouter) {
        attachChild(child)

        currentChild = child
        view.embedIn(child.view, animated: true)
    }

    private func detachChildWithPop(_ child: ViewableRouter) {
        guard currentChild === child else {
            // TODO: Add logs
            return
        }

        detachChild(child)
        currentChild = nil
        view.popViewController(animated: true)
    }

}
