import CaBSDK
import UIKit
import Foundation

public enum SelectableButtonState {

    public typealias Action = CaBButton.Action

    case selected(action: Action?)
    case deselected(action: Action?)

}

@IBDesignable
public final class SelectableButton: CaBButton {

    // MARK: - Public Types

    public typealias Action = CaBButton.Action

    // MARK: - Public Properties

    public private(set) var buttonState: SelectableButtonState = .deselected(action: {}) {
        didSet {
            switch buttonState {
                case let .selected(action):
                    backgroundColor = stateColors?.secondary
                    setTitleColor(stateColors?.primary, for: .normal)
                    if let action = action {
                        DispatchQueue.main.async {
                            action()
                        }
                    }

                case let .deselected(action):
                    backgroundColor = stateColors?.primary
                    setTitleColor(stateColors?.secondary, for: .normal)
                    if let action = action {
                        DispatchQueue.main.async {
                            action()
                        }
                    }
            }
        }
    }

    // MARK: - Private Properties

    private var stateColors: (primary: UIColor?, secondary: UIColor?)?

    // MARK: - Overrides

    public override func apply(configuration: CaBUIConfiguration) {
        super.apply(configuration: configuration)

        stateColors = (primary: configuration.backgroundColor, secondary: configuration.textColor)
    }

    public override func handle(action: @escaping Action) {
        switch buttonState {
            case .selected:
                buttonState = .deselected(action: action)

            case .deselected:
                buttonState = .selected(action: action)
        }
    }

}
