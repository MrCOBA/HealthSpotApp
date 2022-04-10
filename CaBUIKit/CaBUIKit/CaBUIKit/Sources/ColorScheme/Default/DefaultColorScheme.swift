import UIKit


extension CaBColorScheme {

    enum Default {

        static var attributesPrimaryColor: UIColor {
            return UIColor(named: "AttributesPrimary_Default",
                           in: .uikit,
                           compatibleWith: nil) ?? UIColor()
        }

        static var attributesSecondaryColor: UIColor {
            return UIColor(named: "AttributesSecondary_Default",
                           in: .uikit,
                           compatibleWith: nil) ?? UIColor()
        }

        static var attributesTertiaryColor: UIColor {
            return UIColor(named: "AttributesTertiary_Default",
                           in: .uikit,
                           compatibleWith: nil) ?? UIColor()
        }

        static var backgroundPrimaryColor: UIColor {
            return UIColor(named: "BackgroundPrimary_Default",
                           in: .uikit,
                           compatibleWith: nil) ?? UIColor()
        }

        static var backgroundSecondaryColor: UIColor {
            return UIColor(named: "BackgroundSecondary_Default",
                           in: .uikit,
                           compatibleWith: nil) ?? UIColor()
        }

        static var highlightPrimaryColor: UIColor {
            return UIColor(named: "HighlightPrimary_Default",
                           in: .uikit,
                           compatibleWith: nil) ?? UIColor()
        }

        static var highlightSecondaryColor: UIColor {
            return UIColor(named: "HighlightSecondary_Default",
                           in: .uikit,
                           compatibleWith: nil) ?? UIColor()
        }

        static var errorColor: UIColor {
            return UIColor(named: "Error_Default",
                           in: .uikit,
                           compatibleWith: nil) ?? UIColor()
        }

        static var warningColor: UIColor {
            return UIColor(named: "Warning_Default",
                           in: .uikit,
                           compatibleWith: nil) ?? UIColor()
        }

        static var successColor: UIColor {
            return UIColor(named: "Success_Default",
                           in: .uikit,
                           compatibleWith: nil) ?? UIColor()
        }

        static var infoColor: UIColor {
            return UIColor(named: "Info_Default",
                           in: .uikit,
                           compatibleWith: nil) ?? UIColor()
        }

    }

}
