import UIKit

extension UIImage {

    static var sliderThumbImage: UIImage {
        return UIImage(named: "sliderThumbImage",
                       in: .uikit,
                       compatibleWith: nil) ?? UIImage()
    }


}
