import UIKit

extension CaBColorScheme {

    enum Sunset {

        static var activePrimaryColor: UIColor {
            return UIColor(named: "ActivePrimary_Sunset",
                           in: .uikit,
                           compatibleWith: nil) ?? UIColor()
        }

        static var activeSecondaryColor: UIColor {
            return UIColor(named: "ActiveSecondary_Sunset",
                           in: .uikit,
                           compatibleWith: nil) ?? UIColor()
        }

        static var attributesColor: UIColor {
            return UIColor(named: "Attributes_Sunset",
                           in: .uikit,
                           compatibleWith: nil) ?? UIColor()
        }

        static var backgroundPrimaryColor: UIColor {
            return UIColor(named: "BackgroundPrimary_Sunset",
                           in: .uikit,
                           compatibleWith: nil) ?? UIColor()
        }

        static var backgroundSecondaryColor: UIColor {
            return UIColor(named: "BackgroundSecondary_Sunset",
                           in: .uikit,
                           compatibleWith: nil) ?? UIColor()
        }

        static var textColor: UIColor {
            return UIColor(named: "Text_Sunset",
                           in: .uikit,
                           compatibleWith: nil) ?? UIColor()
        }

    }

}
