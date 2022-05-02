import CaBRiblets
import CaBUIKit
import CaBSDK
import UIKit

public enum AuthorizationResult {
    case success
    case failure
}

public protocol AuthorizationContainerRouter: AnyObject {
    func attachSignInScreen()
    func attachSignUpScreen()
    func attachInfoScreen(with result: AuthorizationResult)
}

final class AuthorizationContainerRouterImpl: BaseRouter, AuthorizationContainerRouter {

    // MARK: - Public Properties

    public var view: UINavigationController

    // MARK: - Private Properties

    private let interactor: AuthorizationContainerInteractor
    private var currentChild: ViewableRouter?

    // MARK: - Init

    public init(view: UINavigationController, interactor: AuthorizationContainerInteractor) {
        self.view = view
        self.interactor = interactor

        super.init(interactor: interactor)
    }

    // MARK: - Public Methods

    public func attachSignInScreen() {
        let router = AuthorizationBuilder(listener: interactor).build(mode: .signIn)
        attachChildWithEmbed(router)
    }

    public func attachSignUpScreen() {
        let router = AuthorizationBuilder(listener: interactor).build(mode: .signUp)
        attachChildWithPush(router)
    }

    public func attachInfoScreen(with result: AuthorizationResult) {

    }

    // MARK: - Private Methods

    private func attachChildWithPush(_ child: ViewableRouter) {
        if currentChild != nil {
            detachChildWithPop(child)
            self.currentChild = nil
        }

        attachChild(child)

        self.currentChild = child
        view.pushViewController(child.view, animated: true)
    }

    private func attachChildWithEmbed(_ child: ViewableRouter) {
        attachChild(child)

        view.embedIn(child.view, animated: true)
    }

    private func detachChildWithPop(_ child: ViewableRouter) {
        guard currentChild === child else {
            logWarning(message: "There is no child to detach")
            return
        }

        detachChild(child)
        currentChild = nil
        view.popViewController(animated: true)
    }

}
