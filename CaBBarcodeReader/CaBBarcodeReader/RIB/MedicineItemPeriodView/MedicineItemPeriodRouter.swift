import UIKit
import CaBRiblets

final class MedicineItemPeriodRouter: BaseRouter, ViewableRouter {

    // MARK: - Internal Properties

    var view: UIViewController

    // MARK: - Init
    
    init(view: UIViewController, interactor: Interactor) {
        self.view = view

        super.init(interactor: interactor)
    }

}
