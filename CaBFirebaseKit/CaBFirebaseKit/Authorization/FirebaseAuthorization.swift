import FirebaseAuth

// MARK: - Protocols

public protocol FirebaseAuthorizationDelegate: AnyObject {

    func didSignIn(with error: Error?)
    func didSignUp(with error: Error?)

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
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] _, error in
            self?.delegate?.didSignIn(with: error)
        }
    }

    func signUp(email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] _, error in
            self?.delegate?.didSignUp(with: error)
        }
    }

}
