import CaBFoundation

// MARK: - Protocols

public protocol HealthActivityStatisticsStorageObserver: AnyObject {

    func storage(_ storage: HealthActivityStatisticsStorage,
                 didUpdateHeartRateTo newValue: Double)

    func storage(_ storage: HealthActivityStatisticsStorage,
                 didUpdateStepsCountTo newValue: Double)

    func storage(_ storage: HealthActivityStatisticsStorage,
                 didUpdateBurnedCalloriesTo newValue: Double)

    func storage(_ storage: HealthActivityStatisticsStorage,
                 didUpdateHeartRateNormTo newValue: Double)

    func storage(_ storage: HealthActivityStatisticsStorage,
                 didUpdateStepsGoalTo newValue: Double)

    func storage(_ storage: HealthActivityStatisticsStorage,
                 didUpdateCalloriesGoalTo newValue: Double)

}

public extension HealthActivityStatisticsStorageObserver {

    func storage(_ storage: HealthActivityStatisticsStorage,
                 didUpdateHeartRateTo newValue: Double) {
        /* Do Nothing */
    }

    func storage(_ storage: HealthActivityStatisticsStorage,
                 didUpdateStepsCountTo newValue: Double) {
        /* Do Nothing */
    }

    func storage(_ storage: HealthActivityStatisticsStorage,
                 didUpdateBurnedCalloriesTo newValue: Double) {
        /* Do Nothing */
    }

    func storage(_ storage: HealthActivityStatisticsStorage,
                 didUpdateHeartRateNormTo newValue: Double) {
        /* Do Nothing */
    }

    func storage(_ storage: HealthActivityStatisticsStorage,
                 didUpdateStepsGoalTo newValue: Double) {
        /* Do Nothing */
    }

    func storage(_ storage: HealthActivityStatisticsStorage,
                 didUpdateCalloriesGoalTo newValue: Double) {
        /* Do Nothing */
    }

}

public protocol HealthActivityStatisticsStorage: AnyObject {

    typealias Observer = HealthActivityStatisticsStorageObserver

    var heartRate: Double { get set }
    var stepsCount: Double { get set }
    var burnedCallories: Double { get set }

    var heartRateNorm: Double { get set }
    var stepsGoal: Double { get set }
    var calloriesGoal: Double { get set }

    var isTrackingEnabled: Bool { get set }

    func add(observer: Observer)
    func remove(observer: Observer)

}

// MARK: - Implementation

final class HealthActivityStatisticsStorageImpl: HealthActivityStatisticsStorage, ObservablePropertyOnChangeHandlerProvider {

    // MARK: - Private Types

    private typealias Key = UserDefaults.Key.HealthActivityStatistics

    // MARK: - Internal Properties

    @ObservableUserDefaultsStored
    var heartRate: Double

    @ObservableUserDefaultsStored
    var stepsCount: Double

    @ObservableUserDefaultsStored
    var burnedCallories: Double

    @ObservableUserDefaultsStored
    var heartRateNorm: Double

    @ObservableUserDefaultsStored
    var stepsGoal: Double

    @ObservableUserDefaultsStored
    var calloriesGoal: Double

    @UserDefaultsStored
    var isTrackingEnabled: Bool

    // MARK: - Private Properties

    private let observers = ObserversCollection<Observer>()

    // MARK: - Init

    init(userDefults: UserDefaults = .standard) {
        _heartRate = ObservableUserDefaultsStored(underlyingDefaults: userDefults, key: Key.heartRate, defaultValue: 0)
        _stepsCount = ObservableUserDefaultsStored(underlyingDefaults: userDefults, key: Key.stepsCount, defaultValue: 0)
        _burnedCallories = ObservableUserDefaultsStored(underlyingDefaults: userDefults, key: Key.burnedCallories, defaultValue: 0)
        _heartRateNorm = ObservableUserDefaultsStored(underlyingDefaults: userDefults, key: Key.heartRateNorm, defaultValue: 0)
        _stepsGoal = ObservableUserDefaultsStored(underlyingDefaults: userDefults, key: Key.stepsGoal, defaultValue: 0)
        _calloriesGoal = ObservableUserDefaultsStored(underlyingDefaults: userDefults, key: Key.calloriesGoal, defaultValue: 0)
        _isTrackingEnabled = UserDefaultsStored(underlyingDefaults: userDefults, key: Key.isTrackingEnabled, defaultValue: false)

        setupObserving()
    }

    // MARK: - Internal Methods

    func add(observer: Observer) {
        observers.add(observer)
    }

    func remove(observer: Observer) {
        observers.remove(observer)
    }

    // MARK: - Private Methods

    private func setupObserving() {
        _heartRate.observe(onChange: notify(observers) { this, observer, _, newValue in
            observer.storage(this, didUpdateHeartRateTo: newValue)
        })

        _stepsCount.observe(onChange: notify(observers) { this, observer, _, newValue in
            observer.storage(this, didUpdateStepsCountTo: newValue)
        })

        _burnedCallories.observe(onChange: notify(observers) { this, observer, _, newValue in
            observer.storage(this, didUpdateBurnedCalloriesTo: newValue)
        })

        _heartRateNorm.observe(onChange: notify(observers) { this, observer, _, newValue in
            observer.storage(this, didUpdateHeartRateNormTo: newValue)
        })

        _stepsGoal.observe(onChange: notify(observers) { this, observer, _, newValue in
            observer.storage(this, didUpdateStepsGoalTo: newValue)
        })

        _calloriesGoal.observe(onChange: notify(observers) { this, observer, _, newValue in
            observer.storage(this, didUpdateCalloriesGoalTo: newValue)
        })
    }

}
