import UIKit
import CaBUIKit

class HealthActivityTableViewCell: UITableViewCell {

    // MARK: - Internal Types

    struct Context: Equatable {

        let heartRateViewModel: HeartRateActivityView.ViewModel
        let lifeViewModel: LifeActivityView.ViewModel
        let calloriesViewModel: CalloriesActivityView.ViewModel

        static var empty: Self {
            return .init(heartRateViewModel: .empty, lifeViewModel: .empty, calloriesViewModel: .empty)
        }

    }

    // MARK: - Private Types

    private enum Constants {

        static var cornerRadius: CGFloat {
            return 8.0
        }

        static var separatorViewHeight: CGFloat {
            return 1.0
        }

    }

    // MARK: - Internal Properties

    static var nib: UINib {
        return .init(nibName: cellIdentifier, bundle: .main)
    }

    static var cellIdentifier: String {
        return "HealthActivityTableViewCell"
    }

    var colorScheme: CaBColorScheme = .default {
        didSet {
            configure()
        }
    }

    var context: Context = .empty {
        didSet {
            if oldValue != context {
                configure()
            }
        }
    }

    // MARK: - Private Properties

    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var activitiesStackView: UIStackView!

    private let heartRateActivityView = HeartRateActivityView()
    private let lifeActivityView = LifeActivityView()
    private let calloriesActivityView = CalloriesActivityView()
    private let activitySwitchView = SwitchView()

    // MARK: - Internal Methods

    override func awakeFromNib() {
        super.awakeFromNib()

        configure()
    }

    private func configure() {
        containerView.layer.cornerRadius = Constants.cornerRadius
        containerView.backgroundColor = .white

        activitiesStackView.removeArrangedSubviews()

        configureHeartRateActivityView()
        activitiesStackView.addArrangedSubview(makeSeparatorView())

        configureLifeActivityView()
        activitiesStackView.addArrangedSubview(makeSeparatorView())

        configureCalloriesActivityView()
        activitiesStackView.addArrangedSubview(makeSeparatorView())

        activitiesStackView.addArrangedSubview(activitySwitchView)
    }

    private func configureHeartRateActivityView() {
        activitiesStackView.addArrangedSubview(heartRateActivityView)
        heartRateActivityView.viewModel = context.heartRateViewModel
        heartRateActivityView.colorScheme = colorScheme
    }

    private func configureLifeActivityView() {
        activitiesStackView.addArrangedSubview(lifeActivityView)
        lifeActivityView.viewModel = context.lifeViewModel
        lifeActivityView.colorScheme = colorScheme
    }

    private func configureCalloriesActivityView() {
        activitiesStackView.addArrangedSubview(calloriesActivityView)
        calloriesActivityView.viewModel = context.calloriesViewModel
        calloriesActivityView.colorScheme = colorScheme
    }

    private func makeSeparatorView() -> UIView {
        let view = UIView()
        view.backgroundColor = .transparentGray20Alpha
        view.heightAnchor.constraint(equalToConstant: Constants.separatorViewHeight).isActive = true
        return view
    }

}
