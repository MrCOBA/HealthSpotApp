import UIKit
import CaBRiblets
import CaBSDK

public final class AuthorizationRouter: BaseRouter, ViewableRouter {

    // MARK: - Public  Properties

    public var view: UIViewController

    // MARK: - Init

    public init(view: AuthorizationView, interactor: AuthorizationInteractor) {
        guard let view = view as? UIViewController else {
            logError(message: "View expected to be UIViewController type")
        }

        self.view = view

        super.init(interactor: interactor)
    }

}
