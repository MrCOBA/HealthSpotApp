
public protocol AutorizationEventsHandler: AnyObject {

    func mainActionButtonTap(data: [AuthorizationViewModel.Key : String])
    func additionalActionButtonTap()

}

public struct AuthorizationViewModel: Equatable {

    public enum Key {
        case email
        case password
        case repeatedPassword
    }

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

    weak var eventsHandler: AutorizationEventsHandler?

    public static var empty: Self {
        return .init(mode: .signUp,
                     textFields: [],
                     mainActionButtonTitle: "",
                     additionalActionButtonState: .hidden,
                     eventsHandler: nil)
    }

    public init(mode: Mode,
                textFields: [TextField],
                mainActionButtonTitle: String,
                additionalActionButtonState: ActionButtonState,
                eventsHandler: AutorizationEventsHandler?) {
        self.mode = mode
        self.textFields = textFields
        self.mainActionButtonTitle = mainActionButtonTitle
        self.additionalActionButtonState = additionalActionButtonState
        self.eventsHandler = eventsHandler
    }

    public static func == (lhs: AuthorizationViewModel, rhs: AuthorizationViewModel) -> Bool {
        return (lhs.mode == rhs.mode)
        && (lhs.textFields == rhs.textFields)
        && (lhs.mainActionButtonTitle == rhs.mainActionButtonTitle)
        && (lhs.additionalActionButtonState == rhs.additionalActionButtonState)
        && (lhs.eventsHandler === rhs.eventsHandler)
    }

}
