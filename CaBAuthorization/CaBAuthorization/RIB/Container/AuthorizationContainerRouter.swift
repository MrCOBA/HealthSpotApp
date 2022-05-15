import CaBRiblets
import CaBUIKit
import CaBSDK
import UIKit

public enum AuthorizationResult {
    case success
    case failure
}

public protocol AuthorizationContainerRouter: ViewableRouter {
    func attachScreen(for mode: AuthorizationViewModel.Mode)
}

final class AuthorizationContainerRouterImpl: BaseRouter, AuthorizationContainerRouter {

    // MARK: - Internal Properties

    var view: UIViewController {
        return containerViewController
    }

    // MARK: - Private Properties

    private let rootServices: AuthorizationRootServices
    private var containerViewController: CaBNavigationController
    private let interactor: AuthorizationContainerInteractor
    private var rootChild: ViewableRouter?

    // MARK: - Init

    init(rootServices: AuthorizationRootServices, view: CaBNavigationController, interactor: AuthorizationContainerInteractor) {
        self.rootServices = rootServices
        self.containerViewController = view
        self.interactor = interactor

        super.init(interactor: interactor)
    }

    override func start() {
        super.start()

        attachRoot()
    }

    // MARK: - Public Methods

    public func attachScreen(for mode: AuthorizationViewModel.Mode) {
        attachChildWithEmbed(makeAuthorizationRouter(with: mode))
    }

    // MARK: - Private Methods

    private func makeAuthorizationRouter(with mode: AuthorizationViewModel.Mode) -> ViewableRouter {
        return AuthorizationBuilder(factory: rootServices, listener: interactor).build(mode: mode)
    }

    private func attachRoot() {
        attachScreen(for: .signIn)
    }

    private func attachChildWithEmbed(_ child: ViewableRouter) {
        if rootChild != nil {
            rootChild?.stop()
        }

        rootChild = child
        rootChild?.start()
        containerViewController.embedIn(child.view, animated: true)
    }

}
