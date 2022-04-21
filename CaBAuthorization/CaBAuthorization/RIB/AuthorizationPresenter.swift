import CaBRiblets
import UIKit

protocol AuthorizationPresenter: AnyObject {

    func update(for mode: AuthorizationViewModel.Mode)

}

final class AuthorizationPresenterImpl: AuthorizationPresenter {

    weak var view: UIView?

    init() {

    }

    func update(for mode: AuthorizationViewModel.Mode) {
        <#code#>
    }

}
