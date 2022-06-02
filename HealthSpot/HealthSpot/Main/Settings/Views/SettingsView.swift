import CaBUIKit
import CaBFoundation
import UIKit

protocol SettingsViewEventsHandler: AnyObject {

    func exitButtonTapped()
    func settingValueChanged(for id: String, to newValue: Any)

}

final class SettingsView: UIViewController {

    private enum Constants {

        static func buttonAlpha(_ isOfflineModeEnabled: Bool) -> CGFloat {
            return isOfflineModeEnabled ? 0.5 : 1.0
        }

    }

    weak var eventsHandler: SettingsViewEventsHandler?

    var dataSource: (source: [SettingsCellModel], isOfflineModeEnabled: Bool) = ([], false) {
        didSet {
            if isViewLoaded {
                configure()
            }
        }
    }

    var colorScheme: CaBColorScheme = .default{
        didSet {
            if isViewLoaded {
                configure()
            }
        }
    }

    @IBOutlet private weak var exitButton: CaBButton!
    @IBOutlet private weak var settingsTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        settingsTableView.register(SwitchSettingsTableViewCell.nib, forCellReuseIdentifier: SwitchSettingsTableViewCell.cellIdentifier)
        settingsTableView.register(StepperSettingsTableViewCell.nib, forCellReuseIdentifier: StepperSettingsTableViewCell.cellIdentifier)
        settingsTableView.rowHeight = UITableView.automaticDimension
        configure()
    }

    private func configure() {
        settingsTableView.reloadData()

        configureExitButton()
    }

    private func configureExitButton() {
        exitButton.isEnabled = !dataSource.isOfflineModeEnabled
        exitButton.alpha = Constants.buttonAlpha(dataSource.isOfflineModeEnabled)
        exitButton.apply(configuration: CaBButtonConfiguration.Service.noticeButton(with: colorScheme))
        exitButton.setTitle("Exit from HealthSpot Account", for: .normal)
    }

}

extension SettingsView: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.source.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cellId = SettingsCellIdentifier(rawValue: dataSource.source[indexPath.row].id) else {
            logError(message: "Unknown cell ID received: <\(dataSource.source[indexPath.row].id)>")
            return UITableViewCell()
        }

        switch cellId {
        case .offlineMode, .notificationsAvailability:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SwitchSettingsTableViewCell.cellIdentifier,
                                                           for: indexPath) as? SwitchSettingsTableViewCell
            else {
                logError(message: "Unexpected cell type, fall to the default")
                return UITableViewCell()
            }

            cell.backgroundColor = .clear
            cell.delegate = self
            cell.colorScheme = colorScheme
            cell.cellModel = dataSource.source[indexPath.row]

            return cell

        case .calloriesStatisticsGoal, .stepsCountStatisticsGoal:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: StepperSettingsTableViewCell.cellIdentifier,
                                                           for: indexPath) as? StepperSettingsTableViewCell
            else {
                logError(message: "Unexpected cell type, fall to the default")
                return UITableViewCell()
            }

            cell.backgroundColor = .clear
            cell.delegate = self
            cell.colorScheme = colorScheme
            cell.cellModel = dataSource.source[indexPath.row]

            return cell
        }
    }

    private func checkIfEventsHandlerSet() {
        guard eventsHandler != nil else {
            logError(message: "EventsHandler expected to be set")
            return
        }
    }

    @IBAction private func exitButtonTapped() {
        checkIfEventsHandlerSet()

        eventsHandler?.exitButtonTapped()
    }

}

extension SettingsView: SettingsTableViewCellDelegate {

    func valueChanged(for id: String, to newValue: Any) {
        checkIfEventsHandlerSet()

        eventsHandler?.settingValueChanged(for: id, to: newValue)
    }

}

// MARK: - View Factory

extension SettingsView {

    static func makeView() -> SettingsView {
        return UIStoryboard.SettingsView.instantiateSettingsViewController()
    }

}
