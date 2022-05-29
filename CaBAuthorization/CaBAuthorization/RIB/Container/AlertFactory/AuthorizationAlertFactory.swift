import UIKit

public final class AuthorizationAlertFactory {

    // MARK: - Internal Types

    public enum AlertType {
        case passwordsDoNotMatch
        case notAllFieldsAreFilledIn
        case incorrectFormat
        case noInternetConnection
    }

    // MARK: - Internal Methods

    public func makeAlert(of type: AlertType) -> UIAlertController {
        let alert = UIAlertController(title: type.title, message: type.message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))

        return alert
    }
    
}

// MARK: - Helpers

extension AuthorizationAlertFactory.AlertType {

    fileprivate var title: String {
        switch self {
        case .incorrectFormat:
            return "Incorrect input format!"

        case .notAllFieldsAreFilledIn:
            return "Not all fields are filled in!"

        case .passwordsDoNotMatch:
            return "Ooups!"

        case .noInternetConnection:
            return "It doesn't work!"
        }
    }

    fileprivate var message: String {
        switch self {
        case .incorrectFormat:
            return "The password contains invalid characters\n or the email is incorrectly formatted."

        case .notAllFieldsAreFilledIn:
            return "Fill in all fields for authorization."

        case .passwordsDoNotMatch:
            return "The passwords entered don't match."

        case .noInternetConnection:
            return "Check your internet connection."
        }
    }

}
