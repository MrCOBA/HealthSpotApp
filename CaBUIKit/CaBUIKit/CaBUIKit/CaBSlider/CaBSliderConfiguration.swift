import UIKit

public final class CaBSliderConfiguration: CaBUIConfiguration {

    // MARK: - Private Types

    private enum Constant {

        static var cornerRadius: CGFloat {
            return 10
        }

        static var borderWidth: CGFloat {
            return 2
        }

    }

    // MARK: - Public Types

    public enum Default {

        public static func general(with colorScheme: CaBColorScheme) -> CaBSliderConfiguration {
            return CaBSliderConfiguration(tintColor: colorScheme.highlightPrimaryColor,
                                          borderColor: colorScheme.highlightPrimaryColor,
                                          externalColors: [
                                            colorScheme.attributesPrimaryColor,
                                            .transparentGray50Alpha
                                          ],
                                          cornerRadius: Constant.cornerRadius,
                                          borderWidth: Constant.borderWidth)
        }

    }

    private init(tintColor: UIColor? = nil,
                 borderColor: UIColor? = nil,
                 externalColors: [UIColor] = [],
                 cornerRadius: CGFloat = 0.0,
                 borderWidth: CGFloat = 0.0) {
        super.init(tintColor: tintColor,
                   borderColor: borderColor,
                   externalColors: externalColors,
                   cornerRadius: cornerRadius,
                   borderWidth: borderWidth)
    }
}
