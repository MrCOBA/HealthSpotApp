import CaBRiblets
import CaBFoundation
import UIKit

enum SettingsCellIdentifier: String, CaseIterable {

    // MARK: General Settings

    case offlineMode
    case notificationsAvailability

    // MARK: Statistics Settings

    case calloriesStatisticsGoal
    case stepsCountStatisticsGoal

}

protocol SettingsPresenter: AnyObject {

    func updateView(with cells: [SettingsCellIdentifier])

}

final class SettingsPresenterImpl: SettingsPresenter {

    weak var view: SettingsView?
    weak var interactor: SettingsInteractor?

    private let healthActivityStatisticsStorage: HealthActivityStatisticsStorage
    private let rootSettingsStorage: RootSettingsStorage

    init(view: SettingsView,
         healthActivityStatisticsStorage: HealthActivityStatisticsStorage,
         rootSettingsStorage: RootSettingsStorage) {
        self.view = view
        self.healthActivityStatisticsStorage = healthActivityStatisticsStorage
        self.rootSettingsStorage = rootSettingsStorage
    }

    func updateView(with cells: [SettingsCellIdentifier] = SettingsCellIdentifier.allCases) {
        let cellModels = makeCellModels(for: cells)


        view?.dataSource = (cellModels, rootSettingsStorage.isOfflineModeOn)
    }

    private func makeCellModels(for cells: [SettingsCellIdentifier]) -> [SettingsCellModel] {
        let cellModels: [SettingsCellModel] = cells.map { cell in
            switch cell {
            case .offlineMode,
                 .notificationsAvailability:
                return makeSwitchCellModel(for: cell)

            case .calloriesStatisticsGoal,
                 .stepsCountStatisticsGoal:
                return makeStepperCellModel(for: cell)
            }
        }

        return cellModels
    }

    private func makeStepperCellModel(for cell: SettingsCellIdentifier) -> StepperSettingsTableViewCell.CellModel {
        switch cell {
        case .stepsCountStatisticsGoal:
            return .init(id: cell.rawValue,
                         settingValue: healthActivityStatisticsStorage.stepsGoal,
                         title: "Daily steps count goal: \(healthActivityStatisticsStorage.stepsGoal) st.",
                         subtitle: "Set a daily step target to be notified of its status.")

        case .calloriesStatisticsGoal:
            return .init(id: cell.rawValue,
                         settingValue: healthActivityStatisticsStorage.calloriesGoal,
                         title: "Daily callories goal: \(healthActivityStatisticsStorage.calloriesGoal) kcal.",
                         subtitle: "Set your expected burned energy per day to control it.")

        case .notificationsAvailability,
             .offlineMode:
            logError(message: "Unexpected cell ID provided: <\(cell.rawValue)>")
            return .empty
        }
    }

    private func makeSwitchCellModel(for cell: SettingsCellIdentifier) -> SwitchSettingsTableViewCell.CellModel {
        switch cell {
        case .notificationsAvailability:
            return .init(id: cell.rawValue,
                         isSettingOn: rootSettingsStorage.isNotificationEnabled,
                         title: "Notifications",
                         subtitle: "Enable to receive notifications.")

        case .offlineMode:
            return .init(id: cell.rawValue,
                         isSettingOn: rootSettingsStorage.isOfflineModeOn,
                         title: "Offline mode",
                         subtitle: "Data synchronisation will be disabled.")

        case .stepsCountStatisticsGoal,
             .calloriesStatisticsGoal:
            logError(message: "Unexpected cell ID provided: <\(cell.rawValue)>")
            return .empty
        }
    }

    private func checkIfInteractorSet() {
        if interactor == nil {
            logError(message: "Interactor expected to be set")
        }
    }

}

extension SettingsPresenterImpl: SettingsViewEventsHandler {

    func exitButtonTapped() {
        checkIfInteractorSet()

        interactor?.exitAccount()
    }

    func settingValueChanged(for id: String, to newValue: Any) {
        checkIfInteractorSet()

        interactor?.changeSetting(for: id, to: newValue)
    }

}
