import CaBRiblets

public protocol AuthorizationPresenter: AnyObject {

    func update(for mode: AuthorizationViewModel.Mode)

}

public final class AuthorizationPresenterImpl: AuthorizationPresenter {

    weak var view: AuthorizationView?

    public init() {

    }
}
