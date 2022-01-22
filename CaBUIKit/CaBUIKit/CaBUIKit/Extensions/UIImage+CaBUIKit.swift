import UIKit

extension UIImage {

    enum Slider {

        static var sliderThumbImage: UIImage {
            return UIImage(named: "sliderThumbImage",
                           in: .uikit,
                           compatibleWith: nil) ?? UIImage()
        }

    }

    enum FeatureInfoView {

        static var barcodeScannerFeature: UIImage {
            return UIImage(named: "barcodeScannerIcon",
                           in: .uikit,
                           compatibleWith: nil) ?? UIImage()
        }

    }

}
