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

        public static func primaryButton(with colorScheme: CaBColorScheme) -> CaBButtonConfiguration {
            return CaBButtonConfiguration(backgroundColor: colorScheme.activePrimaryColor,
                                          textColor: colorScheme.activeSecondaryColor,
                                          borderColor: colorScheme.activeSecondaryColor,
                                          borderWidth: Constant.borderWidth,
                                          cornerRadius: Constant.PrimaryButton.cornerRadius,
                                          font: CaBFont.Comfortaa.regular(size: Constant.fontSize))
        }

        public static func secondaryButton(with colorScheme: CaBColorScheme) -> CaBButtonConfiguration {
            return CaBButtonConfiguration(backgroundColor: colorScheme.activeSecondaryColor,
                                          textColor: colorScheme.activePrimaryColor,
                                          cornerRadius: Constant.PrimaryButton.cornerRadius,
                                          font: CaBFont.Comfortaa.regular(size: Constant.fontSize))
        }
        
    }

    public enum Service {

        public static func generalButton(with colorScheme: CaBColorScheme, icon: UIImage? = nil) -> CaBButtonConfiguration {
            return CaBButtonConfiguration(textColor: colorScheme.textColor,
                                          cornerRadius: Constant.ServiceButton.cornerRadius,
                                          font: CaBFont.Comfortaa.light(size: Constant.fontSize),
                                          icon: icon)
        }

        public static func noticeButton(with colorScheme: CaBColorScheme, icon: UIImage? = nil) -> CaBButtonConfiguration {
            return CaBButtonConfiguration(textColor: colorScheme.attributesColor,
                                          borderColor: colorScheme.attributesColor,
                                          borderWidth: Constant.borderWidth,
                                          cornerRadius: Constant.ServiceButton.cornerRadius,
                                          font: CaBFont.Comfortaa.medium(size: Constant.fontSize),
                                          icon: icon)
        }

        public static func selectableButton(with colorScheme: CaBColorScheme, icon: UIImage? = nil, isSelected: Bool = false) -> CaBButtonConfiguration {
            return CaBButtonConfiguration(backgroundColor: isSelected ? colorScheme.activeSecondaryColor : colorScheme.activePrimaryColor,
                                          textColor: isSelected ? colorScheme.activePrimaryColor : colorScheme.activeSecondaryColor,
                                          borderColor: isSelected ? nil : colorScheme.activeSecondaryColor,
                                          borderWidth: Constant.borderWidth,
                                          cornerRadius: Constant.ServiceButton.cornerRadius,
                                          font: CaBFont.Comfortaa.bold(size: Constant.fontSize),
                                          icon: icon)
        }

    }

    // MARK: - Init & Deinit

    private init(backgroundColor: UIColor = .clear,
                 textColor: UIColor = .black,
                 borderColor: UIColor? = nil,
                 borderWidth: CGFloat = 0.0,
                 cornerRadius: CGFloat = 0.0,
                 font: UIFont = CaBFont.Comfortaa.light(size: 15),
                 icon: UIImage? = nil) {
        super.init(backgroundColor: backgroundColor,
                   textColor: textColor,
                   borderColor: borderColor,
                   cornerRadius: cornerRadius,
                   borderWidth: borderWidth,
                   font: font)
    }

}
