import UIKit
import CaBFoundation

public class FeatureInfoView: UIViewController {

    // MARK: - Private Types

    private typealias Font = CaBFont.Comfortaa

    private enum Constant {

        enum Fonts {

            static var title: UIFont {
                return Font.bold(size: 40)
            }

            static var infoTextView: UIFont {
                return Font.regular(size: 18)
            }

        }

        static var paragraphHeadIndent: CGFloat {
            return 15.0
        }

    }

    // MARK: - Public Properties

    public var viewModel: FeatureInfoViewModel = .empty {
        didSet {
            if viewModel != oldValue {
                updateView(with: viewModel)
            }
        }
    }

    public var colorScheme: CaBColorScheme = .default {
        didSet {
            updateView(with: viewModel)
        }
    }

    // MARK: - Private Properties

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var featureImageView: UIImageView!
    @IBOutlet private weak var featureInfoTextView: UITextView!
    @IBOutlet private weak var actionButton: CaBButton!

    // MARK:
    override public func viewDidLoad() {
        super.viewDidLoad()

        updateView(with: viewModel)
    }

    // MARK: - Private Methods

    private func updateView(with viewModel: FeatureInfoViewModel) {
        view.backgroundColor = colorScheme.backgroundPrimaryColor
        featureImageView.image = .image(for: viewModel.featureID)

        configureTitleLabel(with: viewModel)
        configureActionButton(with: viewModel)
        configureTextView(with: viewModel)
    }

    private func configureTitleLabel(with viewModel: FeatureInfoViewModel) {
        let attributedTitle = NSAttributedString(text: viewModel.name,
                                                 textColor: colorScheme.highlightPrimaryColor,
                                                 font: Constant.Fonts.title)
        titleLabel.attributedText = attributedTitle
    }

    private func configureTextView(with viewModel: FeatureInfoViewModel) {
        featureInfoTextView.attributedText = makeTextViewList(with: viewModel)
    }

    private func makeTextViewList(with viewModel: FeatureInfoViewModel) -> NSAttributedString {
        var listString = ""

        for point in viewModel.featurePoints {
            listString += "\n\u{2022} \(point)"
        }

        let paragraph = NSMutableParagraphStyle()
        paragraph.headIndent = Constant.paragraphHeadIndent

        let attributedString = NSAttributedString(string: listString,
                                                  attributes: [
                                                    .font : Constant.Fonts.infoTextView,
                                                    .foregroundColor : colorScheme.highlightPrimaryColor,
                                                    .paragraphStyle : paragraph
                                                  ])

        return attributedString
    }

    private func configureActionButton(with viewModel: FeatureInfoViewModel) {
        actionButton.isHidden = (viewModel.actionButtonState == .hidden)

        switch viewModel.actionButtonState {
            case .hidden:
                return

            case let .shown(title):
                actionButton.apply(configuration: CaBButtonConfiguration.Default.button(of: .secondary, with: colorScheme))
                actionButton.setTitle(title, for: .normal)
        }
    }

    // MARK: User Actions

    @IBAction private func actionButtonTapped() {
        guard let eventsHandler = viewModel.eventsHandler else {
            logWarning(message: "Eventshandler expected to be set")
            return
        }

        guard let featureID = viewModel.featureID else {
            logWarning(message: "The featureID expected to be specific")
            return
        }

        eventsHandler.actionButtonTap(for: featureID)
    }

}

// MARK: - Helpers

extension UIImage {

    fileprivate static func image(for feature: FeatureInfoViewModel.Feature?) -> UIImage? {
        return nil
    }

}
