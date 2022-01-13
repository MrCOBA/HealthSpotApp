import UIKit
import CaBUIKit

class HomeScreenCell: UITableViewCell {

    // MARK: - Private Types

    private typealias Font = CaBFont.Comfortaa

    private enum Constant {

        enum Fonts {

            static var firstLevel: UIFont {
                return Font.bold(size: 22)
            }

            static var secondLevel: UIFont {
                return Font.regular(size: 15)
            }

            static var thirdLevel: UIFont {
                return Font.light(size: 15)
            }

        }

        enum Shadow {

            static var opacity: Float {
                return 0.5
            }

            static var radius: CGFloat {
                return 5.0
            }

        }

        enum Container {

            static var cornerRadius: CGFloat {
                return 16.0
            }

        }

    }

    // MARK: - Internal Properties

    static var nib: UINib {
        return UINib(nibName: cellIdentifier, bundle: .main)
    }

    static var cellIdentifier: String {
        return "HomeScreenCell"
    }

    var viewModel: HomeScreenCellViewModel = .empty {
        didSet {
            if viewModel != oldValue {
                updateView(with: viewModel)
            }
        }
    }

    var colorScheme: CaBColorScheme = .default {
        didSet {
            updateView(with: viewModel)
        }
    }

    // MARK: - Private Properties

    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!
    @IBOutlet private weak var stateIconImageView: UIImageView!
    @IBOutlet private weak var descriptionTextView: UITextView!
    @IBOutlet private weak var actionHintLabel: UILabel!
    @IBOutlet private weak var actionButton: CaBButton!

    // MARK: - Internal Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()

        updateView(with: viewModel)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        configureShadow()
    }

    // MARK: - Private Methods

    private func updateView(with viewModel: HomeScreenCellViewModel) {
        containerView.backgroundColor = colorScheme.backgroundSecondaryColor
        containerView.layer.cornerRadius = Constant.Container.cornerRadius
        configureShadow()

        configureTitleLabel(with: viewModel)
        configureSubtitleLabel(with: viewModel)
        configureDescriptionTextView(with: viewModel)
        configureActionHintLabel(with: viewModel)
        configureActionButton(with: viewModel)
    }

    private func configureTitleLabel(with viewModel: HomeScreenCellViewModel) {
        let attributedTitle = NSAttributedString(string: viewModel.title,
                                                 attributes: [
                                                    .font : Constant.Fonts.firstLevel,
                                                    .foregroundColor : colorScheme.textColor
                                                 ])
        titleLabel.attributedText = attributedTitle
    }

    private func configureSubtitleLabel(with viewModel: HomeScreenCellViewModel) {
        subtitleLabel.isHidden = viewModel.subtitle == nil

        guard let subtitle = viewModel.subtitle else {
            return
        }

        let attributedSubtitle = NSAttributedString(string: subtitle,
                                                    attributes: [
                                                        .font : Constant.Fonts.thirdLevel,
                                                        .foregroundColor : colorScheme.textColor
                                                    ])
        subtitleLabel.attributedText = attributedSubtitle
    }

    private func configureDescriptionTextView(with viewModel: HomeScreenCellViewModel) {
        descriptionTextView.isHidden = viewModel.description == nil

        guard let description = viewModel.description else {
            return
        }

        let attributedDescription = NSAttributedString(string: description,
                                                       attributes: [
                                                        .font : Constant.Fonts.secondLevel,
                                                        .foregroundColor : colorScheme.textColor
                                                       ])
        descriptionTextView.attributedText = attributedDescription

        descriptionTextView.textContainer.lineFragmentPadding = 0
    }

    private func configureActionHintLabel(with viewModel: HomeScreenCellViewModel) {
        actionHintLabel.isHidden = viewModel.actionHint == nil

        guard let hint = viewModel.actionHint else {
            return
        }

        let attributedHint = NSAttributedString(string: hint,
                                                attributes: [
                                                    .font : Constant.Fonts.thirdLevel,
                                                    .foregroundColor : colorScheme.textColor
                                                ])
        actionHintLabel.attributedText = attributedHint
    }


    private func configureActionButton(with viewModel: HomeScreenCellViewModel) {
        actionButton.isHidden = (viewModel.actionButtonState == .hidden)

        switch viewModel.actionButtonState {
            case .hidden:
                return

            case let .shown(title):
                actionButton.apply(configuration: CaBButtonConfiguration.Default.secondaryButton(with: colorScheme))
                actionButton.setTitle(title, for: .normal)
        }
    }

    private func configureShadow() {
        let containerLayer = containerView.layer

        containerLayer.shadowColor = colorScheme.textColor.cgColor
        containerLayer.shadowRadius = Constant.Shadow.radius
        containerLayer.shadowOpacity = Constant.Shadow.opacity
        containerLayer.shadowOffset = .zero
    }

    // MARK: User Actions

    @IBAction private func actionButtonTapped() {
        guard let eventsHandler = viewModel.eventsHandler else {
            // TODO: Add Log
            return
        }

        eventsHandler.actionButtonTap(forCellWith: viewModel.id)
    }

}