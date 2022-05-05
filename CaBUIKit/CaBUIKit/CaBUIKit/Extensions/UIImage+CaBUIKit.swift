import UIKit

// MARK: - Service Images

extension UIImage {

    public enum Slider {

        public static var sliderThumbImage: UIImage {
            return UIImage(named: "sliderThumbImage",
                           in: .uikit,
                           compatibleWith: nil) ?? UIImage()
        }

    }

}

extension UIImage {

    public convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }

}
