import UIKit

extension UIImage {

    public enum Slider {

        public static var sliderThumbImage: UIImage {
            return UIImage(named: "sliderThumbImage",
                           in: .uikit,
                           compatibleWith: nil) ?? UIImage()
        }

    }

    public enum FeatureInfoView {

        public static var barcodeScannerFeature: UIImage {
            return UIImage(named: "barcodeScannerIcon",
                           in: .uikit,
                           compatibleWith: nil) ?? UIImage()
        }

    }

    public enum Autorization {

        public static var user: UIImage {
            return UIImage(named: "user",
                           in: .uikit,
                           compatibleWith: nil) ?? UIImage()
        }

        public static var newUser: UIImage {
            return UIImage(named: "newUser",
                           in: .uikit,
                           compatibleWith: nil) ?? UIImage()
        }

    }

}
