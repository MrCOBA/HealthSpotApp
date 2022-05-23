
// MARK: - Protocol

public protocol RootSettingsStorage: AnyObject {

    var isNotificationPermissionsRequested: Bool { get set }

}

// MARK: - Implementation

public final class RootSettingsStorageImpl: RootSettingsStorage {

    // MARK: - Public Properties

    @UserDefaultsStored
    public var isNotificationPermissionsRequested: Bool

    // MARK: - Init

    public init(userDefaults: UserDefaults = .standard) {
        self._isNotificationPermissionsRequested = .init(underlyingDefaults: userDefaults,
                                                         key: UserDefaults.Key.Foundation.isNotificationPermissionsRequested,
                                                         defaultValue: false)
    }

}
