import UIKit

public final class CaBTabBarController: UITabBarController {

    public var colorScheme: CaBColorScheme = .default {
        didSet {
            configureTabBar()
        }
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        configureTabBar()
    }

    private func configureTabBar() {
        let appearance = makeAppearance(with: colorScheme)

        tabBar.standardAppearance = appearance
        navigationController?.navigationBar.backgroundColor = appearance.backgroundColor
    }

    private func makeAppearance(with colorScheme: CaBColorScheme) -> UITabBarAppearance {
        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .clear
        appearance.backgroundImage = UIImage(color: .transparentGray20Alpha)

        let itemAppearance = makeItemAppearance(with: colorScheme)
        appearance.stackedLayoutAppearance = itemAppearance
        appearance.inlineLayoutAppearance = itemAppearance
        appearance.compactInlineLayoutAppearance = itemAppearance

        return appearance
    }

    private func makeItemAppearance(with colorScheme: CaBColorScheme) -> UITabBarItemAppearance {
        var attrs = [
            NSAttributedString.Key.foregroundColor: colorScheme.attributesTertiaryColor
        ]

        let itemAppearance = UITabBarItemAppearance()
        itemAppearance.normal.iconColor = colorScheme.attributesTertiaryColor
        itemAppearance.normal.titleTextAttributes = attrs

        attrs = [
            NSAttributedString.Key.foregroundColor: colorScheme.highlightPrimaryColor
        ]
        
        itemAppearance.selected.iconColor = colorScheme.highlightPrimaryColor
        itemAppearance.selected.titleTextAttributes = attrs

        return itemAppearance
    }
    
}
