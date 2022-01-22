public protocol FeatureInfoViewEventsHandler: AnyObject {

    func actionButtonTap(for feature: FeatureInfoViewModel.Feature)

}

public struct FeatureInfoViewModel: Equatable {
    public enum ActionButtonState: Equatable {
        case shown(title: String)
        case hidden
    }
    public enum Feature {
        case barCodeScanner
    }

    let featureID: Feature?
    let name: String
    let featurePoints: [String]
    let actionButtonState: ActionButtonState
    
    weak var eventsHandler: FeatureInfoViewEventsHandler?

    public init(featureID: Feature?,
                name: String,
                featurePoints: [String],
                actionButtonState: ActionButtonState,
                eventsHandler: FeatureInfoViewEventsHandler?) {
        self.featureID = featureID
        self.name = name
        self.featurePoints = featurePoints
        self.actionButtonState = actionButtonState
        self.eventsHandler = eventsHandler
    }

    static var empty: Self {
        return .init(featureID: nil,
                     name: "",
                     featurePoints: [],
                     actionButtonState: .hidden,
                     eventsHandler: nil)
    }

    public static func == (lhs: FeatureInfoViewModel, rhs: FeatureInfoViewModel) -> Bool {
        return (lhs.featureID == rhs.featureID)
        && (lhs.actionButtonState == rhs.actionButtonState)
        && (lhs.featurePoints == rhs.featurePoints)
        && (lhs.name == rhs.name)
        && (lhs.eventsHandler === rhs.eventsHandler)
    }

}
