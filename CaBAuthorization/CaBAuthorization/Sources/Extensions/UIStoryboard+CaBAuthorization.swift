import UIKit
import CaBUIKit
import CaBFoundation

extension UIStoryboard {

    struct AuthorizationView: IdentifiableStoryboard {}
    struct AuthorizationInfoView: IdentifiableStoryboard {}

}

// MARK: - AuthorizationView

extension UIStoryboard.AuthorizationView {

    public static var identifier: String {
        return "AuthorizationView"
    }

    public static var bundle: Bundle {
        return .authorization
    }

    static func instantiateAuthorizationViewController() -> AuthorizationViewImpl {
        return instantiateViewController(withIdentifier: "AuthorizationViewImpl")
    }

}

// MARK: - AuthorizationInfoView

extension UIStoryboard.AuthorizationInfoView {

    public static var identifier: String {
        return "AuthorizationView"
    }

    public static var bundle: Bundle {
        return .authorization
    }

    static func instantiateAuthorizationInfoViewController() -> AuthorizationInfoViewImpl {
        return instantiateViewController(withIdentifier: "AuthorizationInfoViewImpl")
    }

}
