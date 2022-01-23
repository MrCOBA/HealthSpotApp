
public struct AuthorizationViewModel: Equatable {

    public enum Mode: Equatable {
        case signIn
        case signUp
    }

    public enum TextField: Equatable {
        case email(state: InputTextFieldState)
        case password(state: InputTextFieldState)
        case repeatPassword(state: InputTextFieldState)
    }

    public enum ActionButtonState: Equatable {
        case shown(title: String)
        case hidden
    }

    public enum InputTextFieldState: Equatable {
        case shown(placeholder: String)
        case hidden
    }

    let mode: Mode
    let textFields: [TextField]
    let mainActionButtonTitle: String
    let additionalActionButtonState: ActionButtonState

    public static var empty: Self {
        return .init(mode: .signUp,
                     textFields: [],
                     mainActionButtonTitle: "",
                     additionalActionButtonState: .hidden)
    }

    public init(mode: Mode,
                textFields: [TextField],
                mainActionButtonTitle: String,
                additionalActionButtonState: ActionButtonState) {
        self.mode = mode
        self.textFields = textFields
        self.mainActionButtonTitle = mainActionButtonTitle
        self.additionalActionButtonState = additionalActionButtonState
    }

}
