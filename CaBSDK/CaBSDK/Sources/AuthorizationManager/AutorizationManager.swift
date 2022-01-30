import FirebaseAuth

public protocol AuthorizationManager: AnyObject {

    func signIn(email: String, password: String)
    func signUp(email: String, password: String)
    
}

final class AuthorizationManagerImpl: AuthorizationManager {

    func signIn(email: String, password: String) {
        guard checkEmail(email) else {
            NotificationCenter.default.post(name: .Authorization.signIn(result: .failure(error: .incorrectFormat)),
                                            object: nil)
            return
        }

        guard checkPassword(password) else {
            NotificationCenter.default.post(name: .Authorization.signIn(result: .failure(error: .incorrectFormat)),
                                            object: nil)
            return
        }

        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            // TODO: Implement this part of authorization
        }
    }

    func signUp(email: String, password: String) {
        guard checkEmail(email) else {
            NotificationCenter.default.post(name: .Authorization.signUp(result: .failure(error: .incorrectFormat)),
                                            object: nil)
            return
        }

        guard checkPassword(password) else {
            NotificationCenter.default.post(name: .Authorization.signUp(result: .failure(error: .incorrectFormat)),
                                            object: nil)
            return
        }

        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            // TODO: Implement this part of authorization
        }
    }

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

}
