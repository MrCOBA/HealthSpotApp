import UIKit
import CaBUIKit
import CaBFoundation

protocol SettingsCellModel {

    var id: String { get }
    var title: String { get }
    var subtitle: String? { get }

    static var empty: Self { get }

}

// MARK: - Delegate

protocol SettingsTableViewCellDelegate: AnyObject {

    func valueChanged(for id: String, to newValue: Any)
}

final class SwitchSettingsTableViewCell: UITableViewCell {

    // MARK: - Internal Types

    struct CellModel: Equatable, SettingsCellModel {
        let id: String
        let isSettingOn: Bool
        let title: String
        let subtitle: String?

        static var empty: Self {
            return .init(id: "", isSettingOn: false, title: "", subtitle: nil)
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
        return "SwitchSettingsTableViewCell"
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
    @IBOutlet private weak var settingSwitch: CaBSwitch!

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
        if settingSwitch.isOn != cellModel.isSettingOn {
            settingSwitch.isOn = cellModel.isSettingOn
        }

        settingSwitch.apply(configuration: CaBSwitchConfiguration.Default.general(with: colorScheme))

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

        delegate?.valueChanged(for: cellModel.id, to: settingSwitch.isOn)
    }

}
