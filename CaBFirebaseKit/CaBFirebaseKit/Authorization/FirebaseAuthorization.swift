import FirebaseAuth

// MARK: - Protocols

public protocol FirebaseAuthorizationDelegate: AnyObject {

    func didSignIn(id: String?, with error: Error?)
    func didSignUp(id: String?, with error: Error?)

}

public protocol FirebaseAuthorizationController: AnyObject {

    var delegate: FirebaseAuthorizationDelegate? { get set }

    func signIn(email: String, password: String)
    func signUp(email: String, password: String)

}

// MARK: - Implementation

final class FirebaseAuthorizationControllerImpl: FirebaseAuthorizationController {

    // MARK: - Internal Properties

    var delegate: FirebaseAuthorizationDelegate?

    // MARK: - Internal Methods

    func signIn(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            let id = authResult?.user.uid
            self?.delegate?.didSignIn(id: id, with: error)
        }
    }

    func signUp(email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            let id = authResult?.user.uid
            self?.delegate?.didSignUp(id: id, with: error)
        }
    }

}
