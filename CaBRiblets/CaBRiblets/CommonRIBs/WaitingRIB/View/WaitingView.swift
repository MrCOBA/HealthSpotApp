import UIKit
import CaBUIKit

final class WaitingView: UIViewController {

    struct ViewModel: Equatable {

        let title: String

        static var empty: Self {
            return .init(title: "")
        }

    }

    var colorScheme: CaBColorScheme = .default {
        didSet {
            configure()
        }
    }

    var viewModel: ViewModel = .empty {
        didSet {
            if oldValue != viewModel{
                configure()
            }
        }
    }

    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var titleLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
    }

    private func configure() {
        view.backgroundColor = colorScheme.backgroundPrimaryColor

        let attributedTitle = NSAttributedString(text: viewModel.title,
                                                 textColor: colorScheme.highlightPrimaryColor,
                                                 font: CaBFont.Comfortaa.bold(size: 18.0))
        titleLabel.attributedText = attributedTitle

        activityIndicator.tintColor = colorScheme.highlightPrimaryColor
        activityIndicator.style = .large

        activityIndicator.startAnimating()
    }

}

extension WaitingView {

    static func makeView() -> WaitingView {
        return UIStoryboard.WaitingView.instantiateWaitingViewController()
    }

}
