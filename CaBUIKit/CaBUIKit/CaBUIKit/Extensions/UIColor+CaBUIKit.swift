import UIKit

extension UIColor {

    static var green: UIColor {
        return UIColor(named: "Green",
                       in: .uikit,
                       compatibleWith: nil) ?? UIColor()
    }

    static var red: UIColor {
        return UIColor(named: "Red",
                       in: .uikit,
                       compatibleWith: nil) ?? UIColor()
    }

    static var blue: UIColor {
        return UIColor(named: "Blue",
                       in: .uikit,
                       compatibleWith: nil) ?? UIColor()
    }

    static var transparentGray20Alpha: UIColor {
        return UIColor(named: "Gray_Transparent_20",
                       in: .uikit,
                       compatibleWith: nil) ?? UIColor()
    }

    static var transparentGray50Alpha: UIColor {
        return UIColor(named: "Gray_Transparent_50",
                       in: .uikit,
                       compatibleWith: nil) ?? UIColor()
    }

}
