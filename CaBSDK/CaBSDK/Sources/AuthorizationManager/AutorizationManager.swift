import FirebaseAuth

public protocol AuthorizationManager: AnyObject {

    func signIn(email: String, password: String)
    func signUp(email: String, password: String)
    
}

final class AuthorizationManagerImpl: AuthorizationManager {

    func signIn(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            // TODO: Implement this part of authorization
        }
    }

    func signUp(email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            // TODO: Implement this part of authorization
        }
    }

}
