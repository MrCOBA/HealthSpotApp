import CaBFoundation

// MARK: - Protocol

public protocol AuthorithationCredentialsTemporaryStorage: AnyObject {

    var id: String { get set }
    var email: String { get set }
    var password: String { get set }
    var repeatedPassword: String { get set }

    func clear()

}

// MARK: - Implementation

public final class AuthorithationCredentialsTemporaryStorageImpl: AuthorithationCredentialsTemporaryStorage {

    // MARK: - Public Properties

    @UserDefaultsStored
    public var id: String

    @UserDefaultsStored
    public var email: String

    @UserDefaultsStored
    public var password: String

    @UserDefaultsStored
    public var repeatedPassword: String

    // MARK: - Init
    
    public init(userDefaults: UserDefaults = .standard) {
        self._id = .init(underlyingDefaults: userDefaults,
                         key: UserDefaults.Key.Authorization.id,
                         defaultValue: "")
        self._email = .init(underlyingDefaults: userDefaults,
                            key: UserDefaults.Key.Authorization.email,
                            defaultValue: "")
        self._password = .init(underlyingDefaults: userDefaults,
                               key: UserDefaults.Key.Authorization.password,
                               defaultValue: "")
        self._repeatedPassword = .init(underlyingDefaults: userDefaults,
                                       key: UserDefaults.Key.Authorization.repeatedPassword,
                                       defaultValue: "")
    }

    public func clear() {
        id = ""
        email = ""
        password = ""
        repeatedPassword = ""
    }
    
}
