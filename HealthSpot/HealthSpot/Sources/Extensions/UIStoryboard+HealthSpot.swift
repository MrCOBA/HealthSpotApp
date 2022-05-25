import UIKit
import CaBUIKit
import CaBFoundation

extension UIStoryboard {

    struct HomeView: IdentifiableStoryboard {}

}

// MARK: - HomeView

extension UIStoryboard.HomeView {

    static var identifier: String {
        return "HomeView"
    }

    static var bundle: Bundle {
        return .main
    }

    static func instantiateHomeViewController() -> HomeView {
        return instantiateViewController(withIdentifier: "HomeView")
    }

}

