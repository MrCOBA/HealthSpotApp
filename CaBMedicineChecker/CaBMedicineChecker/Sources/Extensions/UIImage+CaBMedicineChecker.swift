import UIKit

extension UIImage {

    enum MedicineChecker {

        public static var placeholderIcon: UIImage {
            return UIImage(named: "medicine-\(Int.random(in: 0..<20))",
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