import UIKit
import CaBUIKit

final class SettingsTableViewCell: UITableViewCell {

    struct CellModel: Equatable {
        let isSettingOn: Bool
        let title: String
        let subtitle: String?

        static var empty: Self {
            return .init(isSettingOn: false, title: "", subtitle: nil)
        }
    }

    static var nib: UINib {
        return .init(nibName: cellIdentifier, bundle: .main)
    }

    static var cellIdentifier: String {
        return "SettingsTableViewCell"
    }

    var cellModel: CellModel = .empty {
        didSet {
            if oldValue != cellModel {
                configure(with: cellModel)
            }
        }
    }

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var settingTitleLabel: UILabel!
    @IBOutlet weak var settingSubtitleLabel: UILabel!
    @IBOutlet weak var settingSwitch: CaBSwitch!


    override func awakeFromNib() {
        super.awakeFromNib()

        configure(with: cellModel)
    }

    private func configure(with cellModel: CellModel) {
        settingTitleLabel.text = cellModel.title
        settingSubtitleLabel.text = cellModel.subtitle
        settingSwitch.isOn = cellModel.isSettingOn
        containerView.layer.cornerRadius = 8.0

        settingSwitch.apply(configuration: CaBSwitchConfiguration.Default.general(with: .default))
    }

}
