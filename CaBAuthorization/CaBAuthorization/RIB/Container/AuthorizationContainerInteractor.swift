import CaBRiblets

public final class AuthorizationContainerInteractor: BaseInteractor {

    private weak var router: AuthorizationContainerRouter?

    public init(router: AuthorizationContainerRouter) {
        self.router = router

        super.init()
    }

}

extension AuthorizationContainerInteractor: AuthorizationListener {

    public func showSignUpScreen() {
    }

    public func returnBack() {
    }

    public func completeAuthorization() {
    }

}
