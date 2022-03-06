import UIKit

// MARK: - General Class

public class CaBUIConfiguration {

    // MARK: - Internal Properties

    public let backgroundColor: UIColor
    public let tintColor: UIColor?
    public let textColor: UIColor?
    public let borderColor: UIColor?
    public let externalColors: [UIColor]
    public let cornerRadius: CGFloat
    public let borderWidth: CGFloat
    public let font: UIFont

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
