import CaBSDK
import CaBFirebaseKit

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

    private let authorizationController: FirebaseAuthorizationController
    private let coreDataAssistant: CoreDataAssistant
    private let temporaryCredentialsStorage: AuthorithationCredentialsTemporaryStorage

    // MARK: - Init

    public init(authorizationController: FirebaseAuthorizationController,
                coreDataAssistant: CoreDataAssistant,
                temporaryCredentialsStorage: AuthorithationCredentialsTemporaryStorage) {
        self.coreDataAssistant = coreDataAssistant
        self.temporaryCredentialsStorage = temporaryCredentialsStorage
        self.authorizationController = authorizationController

        authorizationController.delegate = self
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

        authorizationController.signIn(email: email, password: password)
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

        authorizationController.signUp(email: email, password: password)
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

// MARK: - Protocol FirebaseAuthorizationDelegate

extension AuthorizationManagerImpl: FirebaseAuthorizationDelegate {

    public func didSignIn(with error: Swift.Error?) {
        guard let _ = error else {
            NotificationCenter.default.post(name: .Authorization.signIn(result: .success),
                                            object: nil)
            return
        }

        // TODO: Add error handling
    }

    public func didSignUp(with error: Swift.Error?) {
        guard let _ = error else {
            NotificationCenter.default.post(name: .Authorization.signUp(result: .success),
                                            object: nil)
            return
        }

        // TODO: Add error handling
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
