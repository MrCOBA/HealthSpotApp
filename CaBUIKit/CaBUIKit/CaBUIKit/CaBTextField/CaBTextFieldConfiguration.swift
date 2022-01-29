import UIKit

public final class CaBTextFieldConfiguration: CaBUIConfiguration {

    // MARK: - Private Types

    private enum Constant {

        static var cornerRadius: CGFloat {
            return 8
        }

        static var borderWidth: CGFloat {
            return 1
        }

    }

    // MARK: - Public Types

    public enum Default {

        public static func general(with colorScheme: CaBColorScheme) -> CaBTextFieldConfiguration {
            return CaBTextFieldConfiguration(backgroundColor: .clear,
                                             textColor: colorScheme.textColor,
                                             borderColor: colorScheme.textColor,
                                             cornerRadius: Constant.cornerRadius,
                                             borderWidth: Constant.borderWidth,
                                             font: CaBFont.Comfortaa.regular(size: 16))
        }

    }

    private init(backgroundColor: UIColor = .clear,
                 textColor: UIColor? = nil,
                 borderColor: UIColor? = nil,
                 externalColors: [UIColor] = [],
                 cornerRadius: CGFloat = 0.0,
                 borderWidth: CGFloat = 0.0,
                 font: UIFont = CaBFont.Comfortaa.light(size: 15)) {
        super.init(backgroundColor: backgroundColor,
                   textColor: textColor,
                   borderColor: borderColor,
                   externalColors: externalColors,
                   cornerRadius: cornerRadius,
                   borderWidth: borderWidth,
                   font: font)
    }
}
