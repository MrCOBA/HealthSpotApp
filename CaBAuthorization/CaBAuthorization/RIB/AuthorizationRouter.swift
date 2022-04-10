import CaBRiblets

public final class AuthorizationRouter: BaseRouter {

    // MARK: - Public  Properties

    public var view: AuthorizationView

    // MARK: - Init

    public init(view: AuthorizationView, interactor: AuthorizationInteractor) {
        self.view = view

        super.init(interactor: interactor)
    }

}
