import Foundation

@propertyWrapper
public struct UserDefaultsStored<T> {

    // MARK: - Public Properties

    public var wrappedValue: T {
        get {
            guard let value = underlyingDefaults.object(forKey: key) else {
                logInfo(message: "[\(#file):\(#line)] Storage is empty, no object found for key: <\(key)>")
                return defaultValue
            }

            guard let castedValue = value as? T else {
                logWarning(message: """
                    [\(#file):\(#line)] Expected value of type <\(T.self)>, but has value: <\(value)> - of type: <\(type(of: value))>.
                    Will return `defaultValue` instead.
                    """)
                return defaultValue
            }

            return castedValue
        }
        set {
            if let value = newValue as? OptionalProtocol, value.isNil() {
                underlyingDefaults.removeObject(forKey: key)
            }
            else {
                underlyingDefaults.set(newValue, forKey: key)
            }
        }
    }

    // MARK: - Private Properties

    private let key: String
    private let defaultValue: T
    private let underlyingDefaults: UserDefaults

    // MARK: - Init

    public init(underlyingDefaults: UserDefaults = .standard, key: String, defaultValue: T) {
        self.underlyingDefaults = underlyingDefaults
        self.key = key
        self.defaultValue = defaultValue
    }

    public init?(suiteName: String, key: String, defaultValue: T) {
        guard let defaults = UserDefaults(suiteName: suiteName) else {
            logError(message: "Failed to initialize UserDefaults with suite name <\(suiteName)>")
            return nil
        }

        self.underlyingDefaults = defaults
        self.key = key
        self.defaultValue = defaultValue
    }

}

public extension UserDefaultsStored where T: ExpressibleByNilLiteral {

    init(underlyingDefaults: UserDefaults = .standard, key: String) {
        self.init(underlyingDefaults: underlyingDefaults, key: key, defaultValue: nil)
    }

}

// MARK: - Helpers

fileprivate protocol OptionalProtocol {

    func isNil() -> Bool

}

extension Optional: OptionalProtocol {

    func isNil() -> Bool {
        return self == nil
    }

}
