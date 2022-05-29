
// MARK: - Protocol

public protocol CachedStorage: AnyObject {

    var cache: [String: Any] { get set }

    func clear()

}

// MARK: - Implementation

public final class CachedStorageImpl: CachedStorage {

    // MARK: - Public Properties

    @UserDefaultsStored
    public var cache: [String: Any]

    // MARK: - Init

    public init(userDefaults: UserDefaults = .standard) {
        self._cache = .init(underlyingDefaults: userDefaults,
                            key: UserDefaults.Key.Cache.cachedBuffer,
                            defaultValue: [:])
    }

    public func clear() {
        cache = [:]
    }

}
