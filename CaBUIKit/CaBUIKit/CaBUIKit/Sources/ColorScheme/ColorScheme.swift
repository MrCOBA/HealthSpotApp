import UIKit

public struct CaBColorScheme {

    // MARK: - Public Properties

    public static var sunsetColorScheme: CaBColorScheme {
        return CaBColorScheme(activePrimaryColor: Sunset.activePrimaryColor,
                              activeSecondaryColor: Sunset.activeSecondaryColor,
                              attributesColor: Sunset.attributesColor,
                              backgroundPrimaryColor: Sunset.backgroundPrimaryColor,
                              backgroundSecondaryColor: Sunset.backgroundSecondaryColor,
                              textColor: Sunset.textColor)
    }

    public static var coldRowanColorScheme: CaBColorScheme {
        return CaBColorScheme(activePrimaryColor: ColdRowan.activePrimaryColor,
                              activeSecondaryColor: ColdRowan.activeSecondaryColor,
                              attributesColor: ColdRowan.attributesColor,
                              backgroundPrimaryColor: ColdRowan.backgroundPrimaryColor,
                              backgroundSecondaryColor: ColdRowan.backgroundSecondaryColor,
                              textColor: ColdRowan.textColor)
    }

    public static var springLilacsColorScheme: CaBColorScheme {
        return CaBColorScheme(activePrimaryColor: SpringLilacs.activePrimaryColor,
                              activeSecondaryColor: SpringLilacs.activeSecondaryColor,
                              attributesColor: SpringLilacs.attributesColor,
                              backgroundPrimaryColor: SpringLilacs.backgroundPrimaryColor,
                              backgroundSecondaryColor: SpringLilacs.backgroundSecondaryColor,
                              textColor: SpringLilacs.textColor)
    }

    public static var cappuccinoColorScheme: CaBColorScheme {
        return CaBColorScheme(activePrimaryColor: Cappuccino.activePrimaryColor,
                              activeSecondaryColor: Cappuccino.activeSecondaryColor,
                              attributesColor: Cappuccino.attributesColor,
                              backgroundPrimaryColor: Cappuccino.backgroundPrimaryColor,
                              backgroundSecondaryColor: Cappuccino.backgroundSecondaryColor,
                              textColor: Cappuccino.textColor)
    }

    public let activePrimaryColor: UIColor
    public let activeSecondaryColor: UIColor
    public let attributesColor: UIColor
    public let backgroundPrimaryColor: UIColor
    public let backgroundSecondaryColor: UIColor
    public let textColor: UIColor

}
