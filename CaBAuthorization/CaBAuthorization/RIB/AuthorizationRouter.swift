import CaBRiblets

public final class AuthorizationRouter: BaseRouter {

    // MARK: - Public  Properties

    public var view: UIView

    // MARK: - Init

    public init(view: UIView, interactor: AuthorizationInteractor) {
        self.view = view

        super.init(interactor: interactor)
    }

}
