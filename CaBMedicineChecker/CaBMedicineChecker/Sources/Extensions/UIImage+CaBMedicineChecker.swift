import UIKit

extension UIImage {

    enum MedicineChecker {

        public static func placeholderIcon(id: Int) -> UIImage {
            return UIImage(named: "medicine-\(id)",
                           in: .medicineChecker,
                           compatibleWith: nil) ?? UIImage()
        }

        public static var plainIcon: UIImage {
            return UIImage(named: "plain-icon",
                           in: .medicineChecker,
                           compatibleWith: nil) ?? UIImage()
        }

        public static var reloadIcon: UIImage {
            return UIImage(named: "reload-icon",
                           in: .medicineChecker,
                           compatibleWith: nil) ?? UIImage()
        }

        public static var scanIcon: UIImage {
            return UIImage(named: "scan-icon",
                           in: .medicineChecker,
                           compatibleWith: nil) ?? UIImage()
        }

        public static var dailyIcon: UIImage {
            return UIImage(named: "daily-icon",
                           in: .medicineChecker,
                           compatibleWith: nil) ?? UIImage()
        }

        public static var weeklyIcon: UIImage {
            return UIImage(named: "weekly-icon",
                           in: .medicineChecker,
                           compatibleWith: nil) ?? UIImage()
        }

        public static var monthlyIcon: UIImage {
            return UIImage(named: "monthly-icon",
                           in: .medicineChecker,
                           compatibleWith: nil) ?? UIImage()
        }

        public static var yearlyIcon: UIImage {
            return UIImage(named: "yearly-icon",
                           in: .medicineChecker,
                           compatibleWith: nil) ?? UIImage()
        }

        public static var noRepeat: UIImage {
            return UIImage(named: "noRepeat-icon",
                           in: .medicineChecker,
                           compatibleWith: nil) ?? UIImage()
        }

    }
}
