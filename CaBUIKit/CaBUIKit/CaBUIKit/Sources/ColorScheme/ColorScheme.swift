import UIKit

public struct CaBColorScheme {

    // MARK: - Public Properties

    public static var `default`: CaBColorScheme {
        return cabDefaultColorScheme
    }

    // TODO: Refactor & add another schemes for new color configurations

    private static var cabDefaultColorScheme: CaBColorScheme {
        return .init(attributesPrimaryColor: CaBColorScheme.Default.attributesPrimaryColor,
                     attributesSecondaryColor: CaBColorScheme.Default.attributesSecondaryColor,
                     attributesTertiaryColor: CaBColorScheme.Default.attributesTertiaryColor,
                     backgroundPrimaryColor: CaBColorScheme.Default.backgroundPrimaryColor,
                     backgroundSecondaryColor: CaBColorScheme.Default.backgroundSecondaryColor,
                     highlightPrimaryColor: CaBColorScheme.Default.highlightPrimaryColor,
                     highlightSecondaryColor: CaBColorScheme.Default.highlightSecondaryColor,
                     errorColor: CaBColorScheme.Default.errorColor,
                     warningColor: CaBColorScheme.Default.warningColor,
                     successColor: CaBColorScheme.Default.successColor,
                     infoColor: CaBColorScheme.Default.infoColor)
    }

    public let attributesPrimaryColor: UIColor
    public let attributesSecondaryColor: UIColor
    public let attributesTertiaryColor: UIColor

    public let backgroundPrimaryColor: UIColor
    public let backgroundSecondaryColor: UIColor

    public let highlightPrimaryColor: UIColor
    public let highlightSecondaryColor: UIColor

    public let errorColor: UIColor
    public let warningColor: UIColor
    public let successColor: UIColor
    public let infoColor: UIColor

}
