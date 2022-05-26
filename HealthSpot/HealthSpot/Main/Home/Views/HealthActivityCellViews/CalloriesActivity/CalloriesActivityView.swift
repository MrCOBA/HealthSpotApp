import UIKit
import CaBUIKit

class CalloriesActivityView: BaseActivityView {

    // MARK: - Internal Types

    struct ViewModel: Equatable {

        let currentCalloriesBurnt: Double
        let goalCallories: Double

        static var empty: Self {
            return .init(currentCalloriesBurnt: 0.0, goalCallories: 0.0)
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

        iconImageView.image = .HealthActivity.calloriesFeatureIcon
        configureCalloriesBurntLabel(with: viewModel)
        configureGoalLabel(with: viewModel)
    }

    private func configureCalloriesBurntLabel(with viewModel: ViewModel) {
        let attributedCalloriesBurnt = NSAttributedString(text: "\(viewModel.currentCalloriesBurnt) kcal",
                                                          textColor: colorScheme.highlightPrimaryColor,
                                                          font: Constants.Fonts.generalLabelFont)

        generalInfoLabel.attributedText = attributedCalloriesBurnt
    }

    private func configureGoalLabel(with viewModel: ViewModel) {
        let attributedGoal = NSAttributedString(text: "Goal: \(viewModel.currentCalloriesBurnt) kcal / \(viewModel.goalCallories) kcal",
                                                textColor: colorScheme.attributesTertiaryColor,
                                                font: Constants.Fonts.stateLabelFont)

        stateLabel.attributedText = attributedGoal
    }

}
