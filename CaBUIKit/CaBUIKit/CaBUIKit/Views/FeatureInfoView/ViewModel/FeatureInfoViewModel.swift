public struct FeatureInfoViewModel: Equatable {

    public typealias ActionHandler = () -> Void

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
    let actionHandler: ActionHandler?

    public init(featureID: Feature?,
                name: String,
                featurePoints: [String],
                actionButtonState: ActionButtonState,
                actionHandler: ActionHandler?) {
        self.featureID = featureID
        self.name = name
        self.featurePoints = featurePoints
        self.actionButtonState = actionButtonState
        self.actionHandler = actionHandler
    }

    static var empty: Self {
        return .init(featureID: nil,
                     name: "",
                     featurePoints: [],
                     actionButtonState: .hidden,
                     actionHandler: nil)
    }

    public static func == (lhs: FeatureInfoViewModel, rhs: FeatureInfoViewModel) -> Bool {
        return (lhs.featureID == rhs.featureID)
        && (lhs.actionButtonState == rhs.actionButtonState)
        && (lhs.featurePoints == rhs.featurePoints)
        && (lhs.name == rhs.name)
    }

}
