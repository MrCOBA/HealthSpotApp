import CaBFoundation
import CaBFirebaseKit

// MARK: - Protocol

public protocol AuthorizationManager: AnyObject {

    func signIn(email: String, password: String)
    func signIn()
    func signUp()

}

// MARK: - Implementation

public final class AuthorizationManagerImpl: AuthorizationManager {

    // MARK: - Private Types

    private typealias Error = Notification.Name.Error

    // MARK: - Private Properties

    private let networkMonitor: NetworkMonitor
    private let authorizationController: FirebaseAuthorizationController
    private let coreDataAssistant: CoreDataAssistant
    private let temporaryCredentialsStorage: AuthorithationCredentialsTemporaryStorage

    // MARK: - Init

    public init(networkMonitor: NetworkMonitor,
                authorizationController: FirebaseAuthorizationController,
                coreDataAssistant: CoreDataAssistant,
                temporaryCredentialsStorage: AuthorithationCredentialsTemporaryStorage) {
        self.networkMonitor = networkMonitor
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

        postAuthorizationStartNotification()
        authorizationController.signIn(email: email, password: password)
    }

    public func signIn(email: String, password: String) {
        postAuthorizationStartNotification()
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

        postAuthorizationStartNotification()
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
                                        object: nil,
                                        userInfo: ["error": error])
    }

    private func postAuthorizationStartNotification() {
        NotificationCenter.default.post(name: .Authorization.authorizationStarted,
                                        object: nil,
                                        userInfo: [:])
    }

}

// MARK: - Protocol FirebaseAuthorizationDelegate

extension AuthorizationManagerImpl: FirebaseAuthorizationDelegate {

    public func didSignIn(id: String?, with error: Swift.Error?) {
        guard let _ = error else {
            temporaryCredentialsStorage.id = id ?? ""
            NotificationCenter.default.post(name: .Authorization.signIn(result: .success),
                                            object: nil,
                                            userInfo: ["id": id as Any])
            return
        }

        NotificationCenter.default.post(name: .Authorization.firebaseSignInError,
                                        object: nil,
                                        userInfo: ["error": error as Any])
    }

    public func didSignUp(id: String?, with error: Swift.Error?) {
        guard let _ = error else {
            temporaryCredentialsStorage.id = id ?? ""
            NotificationCenter.default.post(name: .Authorization.signUp(result: .success),
                                            object: nil)
            return
        }

        NotificationCenter.default.post(name: .Authorization.firebaseSignUpError,
                                        object: nil,
                                        userInfo: ["error": error as Any])
    }

}

// MARK: - Helper

extension Notification.Name.Error {

    public static var notAllFieldsAreFilledIn: Self {
        return .init(rawValue: "notAllFieldsAreFilledIn")
    }

    public static var passwordsDoNotMatch: Self {
        return .init(rawValue: "passwordsDoNotMatch")
    }

}
