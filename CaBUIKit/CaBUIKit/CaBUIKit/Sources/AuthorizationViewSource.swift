import CaBSDK
import UIKit

final public class AuthorizationViewSource {

    // MARK: - Private Types

    private typealias CredentialsDataSource = [AuthorizationViewModel.Key : String]

    // MARK: - Public Properties

    public var sharedView: AuthorizationView {
        return view
    }

    // MARK: - Private Properties

    private let authorizationManager: AuthorizationManager
    private let view: AuthorizationView

    // MARK: - Init

    public init(authorizationManager: AuthorizationManager) {
        self.authorizationManager = authorizationManager

        self.view = AuthorizationViewSource.makeView()
    }

    // MARK: - Public Methods
    
    public func makeViewModel(for mode: AuthorizationViewModel.Mode) -> AuthorizationViewModel {
        let mainActionButtonTitle: String
        let additionalActionButtonState: AuthorizationViewModel.ActionButtonState
        var textFields: [AuthorizationViewModel.TextField] = [
            .email(state: .shown(placeholder: "E-Mail...")),
            .password(state: .shown(placeholder: "Password..."))
        ]

        switch mode {
            case .signIn:
                mainActionButtonTitle = "Sign in"
                additionalActionButtonState = .shown(title: "No account? Let's create!")
                textFields.append(.repeatPassword(state: .hidden))

            case .signUp:
                mainActionButtonTitle = "Create account!"
                additionalActionButtonState = .hidden
                textFields.append(.repeatPassword(state: .shown(placeholder: "Repeat password...")))
        }

        return .init(mode: mode,
                     textFields: textFields,
                     mainActionButtonTitle: mainActionButtonTitle,
                     additionalActionButtonState: additionalActionButtonState,
                     eventsHandler: self)
    }

    // MARK: - Private Methods

    private static func makeView() -> AuthorizationView {
        let storyboard = UIStoryboard(name: "\(AuthorizationView.self)", bundle: .uikit)

        guard let view = storyboard.instantiateViewController(withIdentifier: "\(AuthorizationView.self)") as? AuthorizationView else {
            //TODO: Add Logs
            return AuthorizationView()
        }

        return view
    }

    private func checkCredentials(data: CredentialsDataSource) {

    }

}

// MARK: - Protocol AutorizationEventsHandler

extension AuthorizationViewSource: AutorizationEventsHandler {

    public func mainActionButtonTap(data: [AuthorizationViewModel.Key : String]) {
        guard let email = data[.email],
              let password = data[.password]
        else {
            return
        }

        authorizationManager.signUp(email: email, password: password)
    }

    public func additionalActionButtonTap() {
        // TODO: Add additional action handling
    }

}
