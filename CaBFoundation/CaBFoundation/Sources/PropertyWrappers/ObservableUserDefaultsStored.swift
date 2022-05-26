import Foundation

@propertyWrapper
public final class ObservableUserDefaultsStored<T: Equatable> {

    // MARK: - Public Types

    public typealias OnChangeHandler = (T, T) -> Void

    // MARK: - Public Properties

    public var wrappedValue: T {
        get {
            return userDefaultsStored
        }
        set {
            userDefaultsStored = newValue
        }
    }

    // MARK: - Private Properties

    private let underlyingDefaults: UserDefaults
    private let key: String
    private let defaultValue: T

    @UserDefaultsStored
    private var userDefaultsStored: T

    private var observer: NSObjectPropertyObserver<T>?

    // MARK: - Init

    public init(underlyingDefaults: UserDefaults = .standard, key: String, defaultValue: T) {
        self.underlyingDefaults = underlyingDefaults
        self.key = key
        self.defaultValue = defaultValue

        _userDefaultsStored = UserDefaultsStored(underlyingDefaults: underlyingDefaults, key: key, defaultValue: defaultValue)
    }

    // MARK: - Public methods

    public func observe(onChange: @escaping OnChangeHandler) {
        observer = NSObjectPropertyObserver(object: underlyingDefaults, forKeyPath: key) { [weak self] oldValue, newValue in
            guard let this = self else {
                return
            }

            let oldValue = oldValue ?? this.defaultValue
            let newValue = newValue ?? this.defaultValue

            if oldValue != newValue {
                DispatchQueue.main.async {
                    onChange(oldValue, newValue)
                }
            }
        }
    }

}

public extension ObservableUserDefaultsStored where T: ExpressibleByNilLiteral {

    convenience init(underlyingDefaults: UserDefaults = .standard, key: String) {
        self.init(underlyingDefaults: underlyingDefaults, key: key, defaultValue: nil)
    }

}
