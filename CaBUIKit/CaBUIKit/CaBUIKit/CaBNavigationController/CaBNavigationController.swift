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

        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.backgroundColor = appearance.backgroundColor
    }

    private func makeAppearance(with colorScheme: CaBColorScheme) -> UINavigationBarAppearance {
        let attrs = [
            NSAttributedString.Key.font: CaBFont.Comfortaa.medium(size: 16),
            NSAttributedString.Key.foregroundColor: colorScheme.highlightPrimaryColor
        ]

        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.titleTextAttributes = attrs
        appearance.backgroundColor = .clear
        appearance.backgroundImage = UIImage(color: .transparentGray50Alpha)

        return appearance
    }

}
