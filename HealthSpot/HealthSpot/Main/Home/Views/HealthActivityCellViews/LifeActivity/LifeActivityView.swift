import UIKit
import CaBUIKit

final class LifeActivityView: BaseActivityView {

    // MARK: - Internal Types

    struct ViewModel: Equatable {

        let currentStepsCount: Double
        let goalStepsCount: Double

        static var empty: Self {
            return .init(currentStepsCount: -1.0, goalStepsCount: -1.0)
        }

    }

    // MARK: - Internal Properties

    var colorScheme: CaBColorScheme = .default {
        didSet {
            configure()
        }
    }

    var viewModel: ViewModel = .empty {
        didSet {
            if oldValue != viewModel {
                configure()
            }
        }
    }

    // MARK: - Interanl Methods

    override func awakeFromNib() {
        super.awakeFromNib()

        configure()
    }

    // MARK: - Private Methods

    private func configure() {
        backgroundColor = .white

        iconImageView.image = .HealthActivity.activityFeatureIcon
        configureStepsCountLabel(with: viewModel)
        configureStateLabel(with: viewModel)
    }

    private func configureStepsCountLabel(with viewModel: ViewModel) {
        let attributedStepsCount = NSAttributedString(text: "\(viewModel.currentStepsCount) steps",
                                                      textColor: colorScheme.highlightPrimaryColor,
                                                      font: Constants.Fonts.generalLabelFont)

        generalInfoLabel.attributedText = attributedStepsCount
    }

    private func configureStateLabel(with viewModel: ViewModel) {
        let attributedState = NSAttributedString(text: "Goal: \(viewModel.currentStepsCount) st / \(viewModel.goalStepsCount) st",
                                                 textColor: colorScheme.attributesTertiaryColor,
                                                 font: Constants.Fonts.stateLabelFont)

        stateLabel.attributedText = attributedState
    }

}
