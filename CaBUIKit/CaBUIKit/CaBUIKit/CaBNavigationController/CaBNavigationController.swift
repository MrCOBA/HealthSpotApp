import UIKit

public final class CaBNavigationController: UINavigationController {

    public var colorScheme: CaBColorScheme = .default {
        didSet {
            configureNavigationBar()
        }
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        configureNavigationBar()
    }

    private func configureNavigationBar() {
        let appearance = makeAppearance(with: colorScheme)

        navigationBar.compactAppearance = appearance
        navigationBar.standardAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
        navigationBar.backgroundColor = appearance.backgroundColor
    }

    private func makeAppearance(with colorScheme: CaBColorScheme) -> UINavigationBarAppearance {
        let attrs = [
            NSAttributedString.Key.font: CaBFont.Comfortaa.bold(size: 16),
            NSAttributedString.Key.foregroundColor: colorScheme.highlightPrimaryColor
        ]

        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.titleTextAttributes = attrs
        appearance.backgroundColor = .clear
        appearance.backgroundImage = UIImage(color: .transparentGray20Alpha)

        return appearance
    }

}
