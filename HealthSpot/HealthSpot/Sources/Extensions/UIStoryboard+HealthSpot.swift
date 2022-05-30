import UIKit
import CaBUIKit
import CaBFoundation

extension UIStoryboard {

    struct HomeView: IdentifiableStoryboard {}
    struct SettingsView: IdentifiableStoryboard {}

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

// MARK: - SettingsView

extension UIStoryboard.SettingsView {

    static var identifier: String {
        return "SettingsView"
    }

    static var bundle: Bundle {
        return .main
    }

    static func instantiateSettingsViewController() -> SettingsView {
        return instantiateViewController(withIdentifier: "SettingsView")
    }

}
