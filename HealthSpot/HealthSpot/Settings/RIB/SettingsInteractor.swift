import CoreData
import CaBRiblets
import CaBFoundation
import CaBFirebaseKit

// MARK: - Protocol

protocol SettingsInteractor: Interactor {

    func exitAccount()
    func changeSetting(for id: String, to newValue: Any)

}

// MARK: - Implementation

final class SettingsInteractorImpl: BaseInteractor, SettingsInteractor {

    // MARK: - Internal Properties

    weak var router: SettingsRouter?
    var presenter: SettingsPresenter?

    private let healthActivityStatisticsStorage: HealthActivityStatisticsStorage
    private let rootSettingsStorage: RootSettingsStorage
    private let cellIdentifiers = SettingsCellIdentifier.allCases

    // MARK: - Init

    init(presenter: SettingsPresenter,
         healthActivityStatisticsStorage: HealthActivityStatisticsStorage,
         rootSettingsStorage: RootSettingsStorage) {
        self.presenter = presenter
        self.healthActivityStatisticsStorage = healthActivityStatisticsStorage
        self.rootSettingsStorage = rootSettingsStorage
    }

    // MARK: - Internal Methods

    override func start() {
        super.start()

        presenter?.updateView(with: cellIdentifiers)
    }

    override func stop() {
        super.stop()
    }

    func exitAccount() {
    }

    func changeSetting(for id: String, to newValue: Any) {
        guard let cellId = SettingsCellIdentifier(rawValue: id) else {
            logError(message: "Unknown cell ID received: <\(id)>")
            return
        }

        switch cellId {
        case .offlineMode:
            rootSettingsStorage.isOfflineModeOn = (newValue as? Bool) ?? false

        case .notificationsAvailability:
            rootSettingsStorage.isNotificationPermissionsRequested = (newValue as? Bool) ?? false

        case .calloriesStatisticsGoal:
            healthActivityStatisticsStorage.calloriesGoal = (newValue as? Double) ?? 0.0

        case .stepsCountStatisticsGoal:
            healthActivityStatisticsStorage.stepsGoal = (newValue as? Double) ?? 0.0
        }

        presenter?.updateView(with: cellIdentifiers)
    }

    // MARK: - Private Methods

    private func checkIfRouterSet() {
        if router == nil {
            logError(message: "Router expected to be set")
        }
    }

}
