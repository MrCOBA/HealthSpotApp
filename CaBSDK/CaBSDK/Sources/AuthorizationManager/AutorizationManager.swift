import FirebaseAuth
import Firebase
import CaBSDK

// MARK: - Protocol

public protocol AuthorizationManager: AnyObject {

    func signIn()
    func signUp()
    
}

// MARK: - Implementation

public final class AuthorizationManagerImpl: AuthorizationManager {

    // MARK: - Private Types

    private typealias Error = Notification.Name.Error

    // MARK: - Private Properties

    private let temporaryCredentialsStorage: AuthorithationCredentialsTemporaryStorage

    // MARK: - Init

    public init(temporaryCredentialsStorage: AuthorithationCredentialsTemporaryStorage) {
        FirebaseApp.configure()

        self.temporaryCredentialsStorage = temporaryCredentialsStorage
    }

    // MARK: - Public Methods

    public func signIn() {
        let email = temporaryCredentialsStorage.email
        let password = temporaryCredentialsStorage.password

        guard email != "",
              password != ""
        else {
            postErrorNotification(.notAllFieldsAreFilledIn)
            return
        }

        guard checkEmailFormat(email) else {
            postErrorNotification(.incorrectFormat)
            return
        }

        guard checkPasswordFormat(password) else {
            postErrorNotification(.incorrectFormat)
            return
        }

        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            guard let _ = error else {
                NotificationCenter.default.post(name: .Authorization.signIn(result: .success),
                                                object: nil)
                return
            }

            // TODO: Add error handling
        }
    }

    public func signUp() {
        let email = temporaryCredentialsStorage.email
        let password = temporaryCredentialsStorage.password
        let repeatedPassword = temporaryCredentialsStorage.repeatedPassword

        guard email != "",
              password != "",
              repeatedPassword != ""
        else {
            postErrorNotification(.notAllFieldsAreFilledIn)
            return
        }

        guard password == repeatedPassword else {
            postErrorNotification(.passwordsDoNotMatch)
            return
        }

        guard checkEmailFormat(email) else {
            postErrorNotification(.incorrectFormat)
            return
        }

        guard checkPasswordFormat(password) else {
            postErrorNotification(.incorrectFormat)
            return
        }

        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            guard let _ = error else {
                NotificationCenter.default.post(name: .Authorization.signIn(result: .success),
                                                object: nil)
                return
            }

            // TODO: Add error handling
        }
    }

    // MARK: - Private Methods

    private func checkEmailFormat(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)

        return emailPred.evaluate(with: email)
    }

    private func checkPasswordFormat(_ password: String) -> Bool {
        let passwordRegEx = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)[a-zA-Z\\d]{8,}$"
        let passwordPred = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)

        return passwordPred.evaluate(with: password)
    }

    private func postErrorNotification(_ error: Error) {
        NotificationCenter.default.post(name: .Authorization.signUp(result: .failure(error: error)),
                                        object: nil)
    }

}

// MARK: - Helper

extension Notification.Name.Error {

    static var notAllFieldsAreFilledIn: Self {
        return .init(rawValue: "notAllFieldsAreFilledIn")
    }

    static var passwordsDoNotMatch: Self {
        return .init(rawValue: "passwordsDoNotMatch")
    }

}
