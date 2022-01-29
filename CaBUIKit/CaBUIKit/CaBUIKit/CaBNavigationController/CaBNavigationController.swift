import UIKit

public final class CaBNavigationController: UINavigationController {

    public override func viewDidLoad() {
        super.viewDidLoad()

        configureNavigationBar()
    }

    private func configureNavigationBar() {
        let appearance = makeAppearance()

        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.backgroundColor = appearance.backgroundColor
    }

    private func makeAppearance() -> UINavigationBarAppearance {
        let attrs = [
            NSAttributedString.Key.font: CaBFont.Comfortaa.bold(size: 20)
        ]

        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.titleTextAttributes = attrs
        appearance.backgroundColor = .clear
        appearance.backgroundImage = UIImage(color: .transparentGray50Alpha)

        return appearance
    }

}

// MARK: - Helper

extension UIImage {

    fileprivate convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }

}
