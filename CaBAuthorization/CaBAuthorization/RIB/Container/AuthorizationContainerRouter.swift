import CaBRiblets
import CaBUIKit
import CaBSDK
import UIKit

public enum AuthorizationResult {
    case success
    case failure
}

protocol AuthorizationContainerRouter: AnyObject {
    func attachSignInScreen()
    func attachSignUpScreen()
    func attachInfoScreen(with result: AuthorizationResult)
}

final class AuthorizationContainerRouterImpl: BaseRouter, AuthorizationContainerRouter {

    // MARK: - Internal Properties

    var view: UINavigationController

    // MARK: - Private Properties

    private let interactor: AuthorizationContainerInteractor

    private var rootChild: ViewableRouter?
    private var currentChild: ViewableRouter?

    // MARK: - Init

    init(view: UINavigationController, interactor: AuthorizationContainerInteractor) {
        self.view = view
        self.interactor = interactor

        super.init(interactor: interactor)
    }

    override func start() {
        super.start()

        attachRoot()
    }

    // MARK: - Internal Methods

    func attachSignInScreen() {
        let router = AuthorizationBuilder(listener: interactor).build(mode: .signIn)
        attachChildWithEmbed(router)
    }

    func attachSignUpScreen() {
        let router = AuthorizationBuilder(listener: interactor).build(mode: .signUp)
        attachChildWithPush(router)
    }

    func attachInfoScreen(with result: AuthorizationResult) {
        let router: ViewableRouter
        switch result {
        case .success:
            router = AuthorizationBuilder(listener: interactor).build(mode: .infoSuccess)
            attachChildWithEmbed(router)
        case .failure:
            router = AuthorizationBuilder(listener: interactor).build(mode: .infoFailure)
            attachChildWithPush(router)
        }
    }

    // MARK: - Private Methods

    private func attachRoot() {
        attachSignInScreen()
    }

    private func attachChildWithPush(_ child: ViewableRouter) {
        if currentChild != nil {
            detachChildWithPop(child)
            currentChild = nil
        }

        attachChild(child)

        currentChild = child
        view.pushViewController(child.view, animated: true)
    }

    private func attachChildWithEmbed(_ child: ViewableRouter) {
        if rootChild != nil {
            detachChild(child)
            rootChild = nil
        }

        attachChild(child)

        rootChild = child
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
