import UIKit
import CaBRiblets

final class BarcodeCaptureRouter: BaseRouter, ViewableRouter {

    var view: UIViewController

    init(view: BarcodeCaptureView, interactor: Interactor) {
        self.view = view
        super.init(interactor: interactor)
    }

}
