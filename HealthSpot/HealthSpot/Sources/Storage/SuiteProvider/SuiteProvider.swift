import Foundation

public final class UserDefaultsSuiteProvider {

    func suite<T>(type: T.Type) -> UserDefaults? {
        return UserDefaults(suiteName: String(describing: type))
    }

    func suite(name: String) -> UserDefaults? {
        return UserDefaults(suiteName: name)
    }

}
