import UIKit
import CaBUIKit
import CaBFoundation

// MARK: - Delegate

final class StepperSettingsTableViewCell: UITableViewCell {

    // MARK: - Internal Types

    struct CellModel: SettingsCellModel {
        let id: String
        let settingValue: Double
        let title: String
        let subtitle: String?

        static var empty: Self {
            return .init(id: "", settingValue: 0, title: "", subtitle: nil)
        }
    }

    // MARK: - Private Types

    private enum Constants {

        enum Fonts {

            static var titleFont: UIFont {
                return CaBFont.Comfortaa.bold(size: 16.0)
            }

            static var subtitleFont: UIFont {
                return CaBFont.Comfortaa.bold(size: 12.0)
            }

        }

        static var cornerRadius: CGFloat {
            return 8.0
        }

    }

    // MARK: - Internal Properties

    weak var delegate: SettingsTableViewCellDelegate?

    static var nib: UINib {
        return .init(nibName: cellIdentifier, bundle: .main)
    }

    static var cellIdentifier: String {
        return "StepperSettingsTableViewCell"
    }

    var colorScheme: CaBColorScheme = .default {
        didSet {
            configure(with: cellModel)
        }
    }

    var cellModel: SettingsCellModel? {
        didSet {
            configure(with: cellModel)
        }
    }

    // MARK: - Private Properties

    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var settingTitleLabel: UILabel!
    @IBOutlet private weak var settingSubtitleLabel: UILabel!
    @IBOutlet private weak var settingStepper: UIStepper!

    // MARK: - Internal Methods

    override func awakeFromNib() {
        super.awakeFromNib()

        configure(with: cellModel)
    }

    // MARK: - Private Methods

    private func configure(with cellModel: SettingsCellModel?) {
        guard let cellModel = cellModel as? CellModel else {
            return
        }

        containerView.layer.cornerRadius = Constants.cornerRadius
        settingStepper.value = cellModel.settingValue

        configureTitleLabel(with: cellModel)
        configureSubtitleLabel(with: cellModel)
    }

    private func configureTitleLabel(with cellModel: CellModel) {
        let attributedTitle = NSAttributedString(text: cellModel.title,
                                                 textColor: colorScheme.highlightPrimaryColor,
                                                 font: Constants.Fonts.titleFont)

        settingTitleLabel.attributedText = attributedTitle
        settingTitleLabel.setLineSpacing(lineSpacing: 1.5)
    }

    private func configureSubtitleLabel(with cellModel: CellModel) {
        if let _ = cellModel.subtitle {
            let attributedSubtitle = NSAttributedString(text: cellModel.subtitle ?? "",
                                                        textColor: colorScheme.attributesTertiaryColor,
                                                        font: Constants.Fonts.subtitleFont)

            settingSubtitleLabel.attributedText = attributedSubtitle
        }

        settingSubtitleLabel.isHidden = (cellModel.subtitle == nil)
    }

    @IBAction private func settingValueChanged(_ sender: Any) {
        guard let cellModel = cellModel else {
            logError(message: "CellModel expected to be set")
            return
        }

        delegate?.valueChanged(for: cellModel.id, to: settingStepper.value)
    }

}
