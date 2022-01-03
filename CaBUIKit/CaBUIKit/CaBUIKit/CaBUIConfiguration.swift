import UIKit

// MARK: - General Class

public class CaBUIConfiguration {

    // MARK: - Internal Properties

    let backgroundColor: UIColor
    let tintColor: UIColor?
    let textColor: UIColor?
    let borderColor: UIColor?
    let externalColors: [UIColor]
    let cornerRadius: CGFloat
    let borderWidth: CGFloat
    let font: UIFont

    // MARK: - Init & Deinit
    
    public init(backgroundColor: UIColor = .clear,
                tintColor: UIColor? = nil,
                textColor: UIColor? = nil,
                borderColor: UIColor? = nil,
                externalColors: [UIColor] = [],
                cornerRadius: CGFloat = 0.0,
                borderWidth: CGFloat = 0.0,
                font: UIFont = CaBFont.Comfortaa.light(size: 15)) {
        self.backgroundColor = backgroundColor
        self.tintColor = tintColor
        self.textColor = textColor
        self.borderColor = borderColor
        self.externalColors = externalColors
        self.cornerRadius = cornerRadius
        self.borderWidth = borderWidth
        self.font = font
    }

}
