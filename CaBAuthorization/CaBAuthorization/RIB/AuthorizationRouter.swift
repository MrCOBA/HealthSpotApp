import UIKit
import CaBRiblets
import CaBFoundation

public final class AuthorizationRouter: BaseRouter, ViewableRouter {

    // MARK: - Public Properties

    public var view: UIViewController

    // MARK: - Init

    public init(view: UIViewController, interactor: AuthorizationInteractor) {
        self.view = view

        super.init(interactor: interactor)
    }

}
