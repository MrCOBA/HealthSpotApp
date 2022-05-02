import FirebaseAuth
import CaBSDK

// MARK: - Protocol

protocol AuthorizationManager: AnyObject {

    func signIn(with credentials: [Int: String])
    func signUp(with credentials: [Int: String])
    
}

// MARK: - Implementation

final class AuthorizationManagerImpl: AuthorizationManager {

    // MARK: - Private Types

    private typealias Error = Notification.Name.Error
    
    private enum CredentialID: Int {
        case email = 0
        case password
        case repeatedPassword
    }

    // MARK: - Private Properties

    private var credentials = [CredentialID: String]()

    // MARK: - Internal Methods

    func signIn(with credentials: [Int: String]) {
        toCredentialID(credentials)

        guard let email = self.credentials[.email], email != "",
              let password = self.credentials[.password], password != ""
        else {
            postErrorNotification(.notAllFieldsAreFilledIn)
            return
        }

        guard checkEmail(email) else {
            postErrorNotification(.incorrectFormat)
            return
        }

        guard checkPassword(password) else {
            postErrorNotification(.incorrectFormat)
            return
        }

        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            // TODO: Implement this part of authorization
        }
    }

    func signUp(with credentials: [Int: String]) {
        guard let email = self.credentials[.email], email != "",
              let password = self.credentials[.password], password != "",
              let repeatedPassword = self.credentials[.repeatedPassword], repeatedPassword != ""
        else {
            postErrorNotification(.notAllFieldsAreFilledIn)
            return
        }

        guard password == repeatedPassword else {
            postErrorNotification(.passwordsDoNotMatch)
            return
        }

        guard checkEmail(email) else {
            postErrorNotification(.incorrectFormat)
            return
        }

        guard checkPassword(password) else {
            postErrorNotification(.incorrectFormat)
            return
        }

        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            // TODO: Implement this part of authorization
        }
    }

    // MARK: - Private Methods

    private func checkEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)

        return emailPred.evaluate(with: email)
    }

    private func checkPassword(_ password: String) -> Bool {
        let passwordRegEx = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)[a-zA-Z\\d]{8,}$"
        let passwordPred = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)

        return passwordPred.evaluate(with: password)
    }

    private func postErrorNotification(_ error: Error) {
        NotificationCenter.default.post(name: .Authorization.signUp(result: .failure(error: error)),
                                        object: nil)
    }

}

// MARK: - Helpers

extension AuthorizationManagerImpl {

    fileprivate func toCredentialID(_ credentials: [Int: String]) {
        credentials.forEach { key, value in
            guard let id = CredentialID(rawValue: key) else {
                logError(message: "Unexpected credential id: <\(key)>")
                return
            }

            self.credentials[id] = value
        }
    }

}

extension Notification.Name.Error {

    static var notAllFieldsAreFilledIn: Self {
        return .init(rawValue: "notAllFieldsAreFilledIn")
    }

    static var passwordsDoNotMatch: Self {
        return .init(rawValue: "passwordsDoNotMatch")
    }

}
