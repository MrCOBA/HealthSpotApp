import UIKit

extension UIImage {

    // MARK: Main
    
    enum Main {

        public static func homeIcon(_ isSelected: Bool) -> UIImage {
            return isSelected
            ? UIImage(named: "home-tab-icon-filled",
                      in: .main,
                      compatibleWith: nil) ?? UIImage()
            : UIImage(named: "home-tab-icon",
                      in: .main,
                      compatibleWith: nil) ?? UIImage()
        }

        public static func medicineIcon(_ isSelected: Bool) -> UIImage {
            return isSelected
            ? UIImage(named: "medicine-tab-icon-filled",
                      in: .main,
                      compatibleWith: nil) ?? UIImage()
            : UIImage(named: "medicine-tab-icon",
                      in: .main,
                      compatibleWith: nil) ?? UIImage()
        }

        public static func foodIcon(_ isSelected: Bool) -> UIImage {
            return isSelected
            ? UIImage(named: "food-tab-icon-filled",
                      in: .main,
                      compatibleWith: nil) ?? UIImage()
            : UIImage(named: "food-tab-icon",
                      in: .main,
                      compatibleWith: nil) ?? UIImage()
        }

        public static func settingsIcon(_ isSelected: Bool) -> UIImage {
            return isSelected
            ? UIImage(named: "settings-tab-icon-filled",
                      in: .main,
                      compatibleWith: nil) ?? UIImage()
            : UIImage(named: "settings-tab-icon",
                      in: .main,
                      compatibleWith: nil) ?? UIImage()
        }

    }

}
