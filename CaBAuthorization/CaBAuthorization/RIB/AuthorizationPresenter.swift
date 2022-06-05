import CaBRiblets
import CaBFoundation
import UIKit

protocol AuthorizationPresenter: AnyObject {

    func update(for mode: AuthorizationViewModel.Mode)

}

final class AuthorizationPresenterImpl: AuthorizationPresenter {

    weak var view: AuthorizationView?
    private weak var interactor: AuthorizationInteractor?

    init(view: AuthorizationView, interactor: AuthorizationInteractor?) {
        self.view = view
        self.interactor = interactor
    }

    func update(for mode: AuthorizationViewModel.Mode) {
        view?.viewModel = makeViewModel(for: mode)
    }

    private func makeViewModel(for mode: AuthorizationViewModel.Mode) -> AuthorizationViewModel {
        var title: String? = nil
        var subtitle: String? = nil
        var hint: String? = nil
        var inputTextFieldsStates = [AuthorizationViewModel.InputTextFieldState]()
        var mainActionButtonTitle: String = ""
        var additionalActionButtonState: AuthorizationViewModel.ActionButtonState
        var backButtonState: AuthorizationViewModel.ActionButtonState

        switch mode {
        case .signIn:
            title = "Sign In to"
            subtitle = "Health Spot Account"
            hint = "Use one account for all ecosystem applications"
            inputTextFieldsStates = [
                .shown(placeholder: "e-mail...", icon: .Autorization.email),
                .shown(placeholder: "password...", icon: .Autorization.lock)
            ]
            mainActionButtonTitle = "Sign In"
            additionalActionButtonState = .shown(title: "Create an account")
            backButtonState = .hidden

        case .signUp:
            subtitle = "Let's create an account..."
            inputTextFieldsStates = [
                .shown(placeholder: "e-mail...", icon: .Autorization.email),
                .shown(placeholder: "password...", icon: .Autorization.password),
                .shown(placeholder: "repeat password...", icon: .Autorization.password)
            ]
            mainActionButtonTitle = "Create"
            additionalActionButtonState = .hidden
            backButtonState = .shown(title: "back to sign in...")

        case .infoFailure:
            title = "Ooops... We’ve got an error!"
            hint = "Try again later..."
            mainActionButtonTitle = "Try again"
            additionalActionButtonState = .hidden
            backButtonState = .shown(title: "back to sign in...")

        case .infoSuccess:
            title = "Great achievement!"
            hint = "Account was created successfully!"
            mainActionButtonTitle = "Let's go!"
            additionalActionButtonState = .hidden
            backButtonState = .hidden
        }

        return .init(mode: mode,
                     textModel: .init(title: title, subtitle: subtitle, hint: hint),
                     inputTextFieldsStates: inputTextFieldsStates,
                     mainActionButtonTitle: mainActionButtonTitle,
                     additionalActionButtonState: additionalActionButtonState,
                     backButtonState: backButtonState)
    }

    private func checkIfInteractorSet() {
        guard interactor != nil else {
            logError(message: "Interactor expected to be set")
            return
        }
    }

}

extension AuthorizationPresenterImpl: AutorizationEventsHandler {

    func mainActionButtonTap(for mode: AuthorizationViewModel.Mode, with credentials: [Int: String]) {
        checkIfInteractorSet()

        switch mode {
        case .signIn:
            interactor?.signIn(with: credentials)

        case .signUp:
            interactor?.signUp(with: credentials)

        case .infoFailure:
            interactor?.showSignInScreen()

        case .infoSuccess:
            interactor?.completeAuthorization()
        }
    }

    func additionalActionButtonTap(for mode: AuthorizationViewModel.Mode) {
        checkIfInteractorSet()
        interactor?.showSignUpScreen()
    }

    func backButtonTap() {
        checkIfInteractorSet()
        interactor?.returnBack()
    }

}
