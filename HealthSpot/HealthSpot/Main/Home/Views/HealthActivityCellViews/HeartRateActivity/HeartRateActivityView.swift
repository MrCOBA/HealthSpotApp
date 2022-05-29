import UIKit
import CaBUIKit

final class HeartRateActivityView: BaseActivityView {

    // MARK: - Internal Types

    struct ViewModel: Equatable {

        enum State: String {
            case normal
            case warning
            case extreme
        }

        let heartRate: Double
        let state: State

        static var empty: Self {
            return .init(heartRate: 0.0, state: .normal)
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

        iconImageView.image = .HealthActivity.pulseFeatureIcon
        configureHeartRateLabel(with: viewModel)
        configureStateLabel(with: viewModel)
    }

    private func configureHeartRateLabel(with viewModel: ViewModel) {
        let roundValue = NSString(format: "%.2f", viewModel.heartRate)
        let attributedHeartRate = NSAttributedString(text: "\(roundValue) BPM",
                                                     textColor: colorScheme.highlightPrimaryColor,
                                                     font: Constants.Fonts.generalLabelFont)

        generalInfoLabel.attributedText = attributedHeartRate
    }

    private func configureStateLabel(with viewModel: ViewModel) {
        let attributedState = NSAttributedString(text: "\(viewModel.state.stateTitle)",
                                                 textColor: viewModel.state.stateColor(colorScheme),
                                                 font: Constants.Fonts.stateLabelFont)

        stateLabel.attributedText = attributedState
    }

}

// MARK: - Helpers

extension HeartRateActivityView.ViewModel.State {

    fileprivate var stateTitle: String {
        switch self {
        case .normal:
            return "Normal state"

        case .warning:
            return "Slightly above normal"

        case .extreme:
            return "Dangerous to health"
        }
    }

    fileprivate func stateColor(_ colorScheme: CaBColorScheme) -> UIColor {
        switch self {
        case .normal:
            return colorScheme.attributesTertiaryColor

        case .warning:
            return colorScheme.warningColor

        case .extreme:
            return colorScheme.errorColor
        }
    }

}
