import Foundation
import UIKit

public final class CaBButtonConfiguration: CaBUIConfiguration {

    // MARK: - Private Types

    private enum Constant {

        enum PrimaryButton {

            static var cornerRadius: CGFloat {
                return 8
            }

        }

        enum ServiceButton {

            static var cornerRadius: CGFloat {
                return 24
            }

        }

        static var fontSize: CGFloat {
            return 16
        }

        static var borderWidth: CGFloat {
            return 1
        }

    }

    // MARK: - Public Types

    public enum Default {

        public enum `Type` {
            case primary
            case secondary
            case tertiary
        }

        public static func button(of type: Type, with colorScheme: CaBColorScheme) -> CaBButtonConfiguration {
            let backgroundColor: UIColor
            switch type {
                case .primary:
                    backgroundColor = colorScheme.attributesPrimaryColor

                case .secondary:
                    backgroundColor = colorScheme.backgroundPrimaryColor

                case .tertiary:
                    backgroundColor = colorScheme.attributesSecondaryColor
            }

            return CaBButtonConfiguration(backgroundColor: backgroundColor,
                                          textColor: colorScheme.highlightPrimaryColor,
                                          borderColor: colorScheme.highlightPrimaryColor,
                                          borderWidth: Constant.borderWidth,
                                          cornerRadius: Constant.PrimaryButton.cornerRadius,
                                          font: CaBFont.Comfortaa.regular(size: Constant.fontSize))
        }
    }

    public enum Service {

        public static func generalButton(with colorScheme: CaBColorScheme, icon: UIImage? = nil) -> CaBButtonConfiguration {
            return CaBButtonConfiguration(textColor: colorScheme.highlightPrimaryColor,
                                          cornerRadius: Constant.ServiceButton.cornerRadius,
                                          font: CaBFont.Comfortaa.light(size: Constant.fontSize),
                                          icon: icon)
        }

        public static func noticeButton(with colorScheme: CaBColorScheme, icon: UIImage? = nil) -> CaBButtonConfiguration {
            return CaBButtonConfiguration(textColor: colorScheme.attributesPrimaryColor,
                                          borderColor: colorScheme.attributesPrimaryColor,
                                          borderWidth: Constant.borderWidth,
                                          cornerRadius: Constant.ServiceButton.cornerRadius,
                                          font: CaBFont.Comfortaa.medium(size: Constant.fontSize),
                                          icon: icon)
        }

        public static func selectableButton(with colorScheme: CaBColorScheme, icon: UIImage? = nil, isSelected: Bool = false) -> CaBButtonConfiguration {
            return CaBButtonConfiguration(backgroundColor: isSelected
                                            ? colorScheme.attributesPrimaryColor
                                            : colorScheme.backgroundPrimaryColor,
                                          textColor: isSelected
                                            ? colorScheme.highlightPrimaryColor
                                            : colorScheme.attributesTertiaryColor,
                                          borderColor: isSelected
                                            ? colorScheme.highlightPrimaryColor
                                            : colorScheme.attributesTertiaryColor,
                                          borderWidth: Constant.borderWidth,
                                          cornerRadius: Constant.ServiceButton.cornerRadius,
                                          font: CaBFont.Comfortaa.bold(size: Constant.fontSize),
                                          icon: icon)
        }

    }

    // MARK: - Public Properties

    public var icon: UIImage?

    // MARK: - Init & Deinit

    private init(backgroundColor: UIColor = .clear,
                 textColor: UIColor = .black,
                 borderColor: UIColor? = nil,
                 borderWidth: CGFloat = 0.0,
                 cornerRadius: CGFloat = 0.0,
                 font: UIFont = CaBFont.Comfortaa.light(size: 15),
                 icon: UIImage? = nil) {
        self.icon = icon
        super.init(backgroundColor: backgroundColor,
                   textColor: textColor,
                   borderColor: borderColor,
                   cornerRadius: cornerRadius,
                   borderWidth: borderWidth,
                   font: font)
    }

}
