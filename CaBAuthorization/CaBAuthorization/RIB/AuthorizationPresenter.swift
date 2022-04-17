import CaBRiblets
import UIKit

public protocol AuthorizationPresenter: AnyObject {

    func update(for mode: AuthorizationViewModel.Mode)

}

public final class AuthorizationPresenterImpl: AuthorizationPresenter {

    weak var view: UIView?

    public init() {

    }
}
