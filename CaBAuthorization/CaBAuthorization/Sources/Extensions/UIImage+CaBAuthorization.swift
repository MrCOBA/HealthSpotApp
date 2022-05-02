import UIKit

extension UIImage {

    public enum Autorization {

        public static var email: UIImage {
            return UIImage(named: "email-icon",
                           in: .authorization,
                           compatibleWith: nil) ?? UIImage()
        }

        public static var password: UIImage {
            return UIImage(named: "password-icon",
                           in: .authorization,
                           compatibleWith: nil) ?? UIImage()
        }

        public static var lock: UIImage {
            return UIImage(named: "lock-icon",
                           in: .authorization,
                           compatibleWith: nil) ?? UIImage()
        }

        public static var error: UIImage {
            return UIImage(named: "error-image",
                           in: .authorization,
                           compatibleWith: nil) ?? UIImage()
        }

        public static var success: UIImage {
            return UIImage(named: "success-image",
                           in: .authorization,
                           compatibleWith: nil) ?? UIImage()
        }

    }

}
