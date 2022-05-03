import UIKit

public protocol AutorizationEventsHandler: AnyObject {

    func mainActionButtonTap(for mode: AuthorizationViewModel.Mode, with credentials: [Int: String])
    func additionalActionButtonTap(for mode: AuthorizationViewModel.Mode)
    func backButtonTap()

}

public struct AuthorizationViewModel: Equatable {

    public struct TextModel: Equatable {
        let title: String?
        let subtitle: String?
        let hint: String?
    }

    public enum Mode: Equatable {
        case signIn
        case signUp
        case infoSuccess
        case infoFailure
    }

    public enum ActionButtonState: Equatable {
        case shown(title: String)
        case hidden
    }

    public enum InputTextFieldState: Equatable {
        case shown(placeholder: String, icon: UIImage?)
        case hidden
    }

    let mode: Mode
    let textModel: TextModel
    let inputTextFieldsStates: [InputTextFieldState]
    let mainActionButtonTitle: String
    let additionalActionButtonState: ActionButtonState
    let backButtonState: ActionButtonState

    weak var eventsHandler: AutorizationEventsHandler?

    public static var empty: Self {
        return .init(mode: .signIn,
                     textModel: .init(title: nil, subtitle: nil, hint: nil),
                     inputTextFieldsStates: [],
                     mainActionButtonTitle: "",
                     additionalActionButtonState: .hidden,
                     backButtonState: .hidden,
                     eventsHandler: nil)
    }

    public init(mode: Mode,
                textModel: TextModel,
                inputTextFieldsStates: [InputTextFieldState],
                mainActionButtonTitle: String,
                additionalActionButtonState: ActionButtonState,
                backButtonState: ActionButtonState,
                eventsHandler: AutorizationEventsHandler?) {
        self.mode = mode
        self.textModel = textModel
        self.inputTextFieldsStates = inputTextFieldsStates
        self.mainActionButtonTitle = mainActionButtonTitle
        self.additionalActionButtonState = additionalActionButtonState
        self.backButtonState = backButtonState
        self.eventsHandler = eventsHandler
    }

    public static func == (lhs: AuthorizationViewModel, rhs: AuthorizationViewModel) -> Bool {
        return (lhs.mode == rhs.mode)
        && (lhs.inputTextFieldsStates == rhs.inputTextFieldsStates)
        && (lhs.mainActionButtonTitle == rhs.mainActionButtonTitle)
        && (lhs.additionalActionButtonState == rhs.additionalActionButtonState)
        && (lhs.backButtonState == rhs.backButtonState)
        && (lhs.eventsHandler === rhs.eventsHandler)
    }

}
