import UIKit

extension NSAttributedString {

    public convenience init(text: String, textColor: UIColor? = nil, font: UIFont? = nil) {
        var attributes = [Key: Any]()

        if let textColor = textColor {
            attributes[.foregroundColor] = textColor
        }

        if let font = font {
            attributes[.font] = font
        }

        self.init(string: text, attributes: attributes)
    }

}
