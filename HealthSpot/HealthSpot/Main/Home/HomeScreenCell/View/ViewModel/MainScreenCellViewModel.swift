
protocol MainScreenCellEventsHandler: AnyObject {

    func actionButtonTap(forCellWith id: Int)

}

struct MainScreenCellViewModel: Equatable {

    public enum ActionButtonState: Equatable {
        case shown(title: String)
        case hidden
    }
    
    let id: Int
    let title: String
    let subtitle: String?
    let description: String?
    let actionHint: String?
    let actionButtonState: ActionButtonState

    weak var eventsHandler: MainScreenCellEventsHandler?

    static var empty: Self {
        return .init(id: -1,
                     title: "",
                     subtitle: nil,
                     description: nil,
                     actionHint: nil,
                     actionButtonState: .hidden,
                     eventsHandler: nil)
    }

    public init(id: Int = -1,
                title: String = "",
                subtitle: String? = nil,
                description: String? = nil,
                actionHint: String? = nil,
                actionButtonState: ActionButtonState = .hidden,
                eventsHandler: MainScreenCellEventsHandler? = nil) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.description = description
        self.actionHint = actionHint
        self.actionButtonState = actionButtonState
        self.eventsHandler = eventsHandler
    }

    public static func == (lhs: MainScreenCellViewModel, rhs: MainScreenCellViewModel) -> Bool {
        return (lhs.id == rhs.id)
        && (lhs.actionHint == rhs.actionHint)
        && (lhs.actionButtonState == rhs.actionButtonState)
        && (lhs.title == rhs.title)
        && (lhs.subtitle == rhs.subtitle)
        && (lhs.eventsHandler === rhs.eventsHandler)
    }

}
