import UIKit

public final class WaitingRouter: BaseRouter, ViewableRouter {

    public var view: UIViewController

    init(view: UIViewController, interactor: Interactor) {
        self.view = view

        super.init(interactor: interactor)
    }

}
