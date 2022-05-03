import UIKit

public final class CaBTextFieldConfiguration: CaBUIConfiguration {

    // MARK: - Private Types

    private enum Constant {

        static var cornerRadius: CGFloat {
            return 8
        }

        static var borderWidth: CGFloat {
            return 2
        }

        static var fontSize: CGFloat {
            return 14
        }

    }

    // MARK: - Public Types

    public struct Placeholder {
        public let text: String?
        public let color: UIColor?
        public let font: UIFont

        public init(text: String?, color: UIColor?, font: UIFont = CaBFont.Comfortaa.light(size: 15)) {
            self.text = text
            self.color = color
            self.font = font
        }

        static var empty: Self {
            return .init(text: nil, color: nil)
        }

    }

    public enum Default {

        public static func general(placeholderText: String? = nil, with colorScheme: CaBColorScheme) -> CaBTextFieldConfiguration {
            return CaBTextFieldConfiguration(backgroundColor: .clear,
                                             textColor: colorScheme.highlightPrimaryColor,
                                             placeholder: .init(text: placeholderText,
                                                                color: colorScheme.attributesTertiaryColor,
                                                                font: CaBFont.Comfortaa.light(size: Constant.fontSize)),
                                             borderColor: colorScheme.attributesPrimaryColor,
                                             cornerRadius: Constant.cornerRadius,
                                             borderWidth: Constant.borderWidth,
                                             font: CaBFont.Comfortaa.light(size: Constant.fontSize))
        }

    }

    // MARK: - Public Properties

    public var placeholder: Placeholder

    // MARK: - Init
    
    private init(backgroundColor: UIColor = .clear,
                 textColor: UIColor? = nil,
                 placeholder: Placeholder = .empty,
                 borderColor: UIColor? = nil,
                 externalColors: [UIColor] = [],
                 cornerRadius: CGFloat = 0.0,
                 borderWidth: CGFloat = 0.0,
                 font: UIFont = CaBFont.Comfortaa.light(size: 15)) {
        self.placeholder = placeholder
        super.init(backgroundColor: backgroundColor,
                   textColor: textColor,
                   borderColor: borderColor,
                   externalColors: externalColors,
                   cornerRadius: cornerRadius,
                   borderWidth: borderWidth,
                   font: font)
    }
}
