
// MARK: - Protocols

public protocol RootSettingsStorageObserver: AnyObject {

    func storage(_ storage: RootSettingsStorage,
                 didUpdateOfflineModeTo newValue: Bool)

}

public protocol RootSettingsStorage: AnyObject {

    typealias Observer = RootSettingsStorageObserver

    var isNotificationPermissionsRequested: Bool { get set }
    var isOfflineModeOn: Bool { get set }

    func add(observer: Observer)
    func remove(observer: Observer)

}

// MARK: - Implementation

public final class RootSettingsStorageImpl: RootSettingsStorage, ObservablePropertyOnChangeHandlerProvider {

    // MARK: - Public Properties

    @UserDefaultsStored
    public var isNotificationPermissionsRequested: Bool

    @ObservableUserDefaultsStored
    public var isOfflineModeOn: Bool

    // MARK: - Private Properties

    private let observers = ObserversCollection<Observer>()

    // MARK: - Init

    public init(userDefaults: UserDefaults = .standard) {
        self._isNotificationPermissionsRequested = .init(underlyingDefaults: userDefaults,
                                                         key: UserDefaults.Key.Foundation.isNotificationPermissionsRequested,
                                                         defaultValue: false)
        self._isOfflineModeOn = .init(underlyingDefaults: userDefaults,
                                      key: UserDefaults.Key.Foundation.isOfflineModeOn,
                                      defaultValue: false)

        setupObserving()
    }

    // MARK: - Internal Methods

    public func add(observer: Observer) {
        observers.add(observer)
    }

    public func remove(observer: Observer) {
        observers.remove(observer)
    }

    // MARK: - Private Methods

    private func setupObserving() {
        _isOfflineModeOn.observe(onChange: notify(observers) { this, observer, _, newValue in
            observer.storage(this, didUpdateOfflineModeTo: newValue)
        })
    }

}
