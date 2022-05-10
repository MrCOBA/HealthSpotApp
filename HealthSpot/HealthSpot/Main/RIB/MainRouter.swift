import UIKit
import CaBUIKit
import CaBRiblets

protocol MainRouter: ViewableRouter {

}

final class MainRouterImpl: BaseRouter, MainRouter {

    var view: UIViewController

    init(view: CaBTabBarController, interactor: MainInteractor) {
        self.view = view

        super.init(interactor: interactor)
    }

}
