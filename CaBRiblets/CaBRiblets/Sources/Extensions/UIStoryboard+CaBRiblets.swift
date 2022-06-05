import UIKit
import CaBUIKit
import CaBFoundation

extension UIStoryboard {

    struct WaitingView: IdentifiableStoryboard {}

}

// MARK: - WaitingView

extension UIStoryboard.WaitingView {

    public static var identifier: String {
        return "WaitingView"
    }

    public static var bundle: Bundle {
        return .riblets
    }

    static func instantiateWaitingViewController() -> WaitingView {
        return instantiateViewController(withIdentifier: "WaitingView")
    }

}
