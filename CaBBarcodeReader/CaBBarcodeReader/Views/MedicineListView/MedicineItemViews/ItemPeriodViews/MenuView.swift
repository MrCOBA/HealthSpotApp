import UIKit
import CaBSDK
import CaBUIKit

protocol ItemPeriodMenuViewDelegate: AnyObject {

    func didSelectAction(for action: MenuAction)

}

struct MenuAction: RawRepresentable, Equatable, Hashable, Comparable {

    // MARK: - Public Types

    public typealias RawValue = String

    // MARK: - Public Properties

    public var rawValue: String

    // MARK: Protocol Hashable

    public var hashValue: Int {
        return rawValue.hashValue
    }

    public init(rawValue: String) {
        self.rawValue = rawValue
    }

    // MARK: Protocol Comparable

    public static func <(lhs: MenuAction, rhs: MenuAction) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }

}

final class ItemPeriodMenuView: UIView {

    enum ID {
        case repeatMenu
        case endDateMenu
    }

    private enum Constants {

        static var cornerRadius: CGFloat {
            return 8.0
        }

        static var font: UIFont {
            return CaBFont.Comfortaa.medium(size: 17.0)
        }

    }

    weak var delegate: ItemPeriodMenuViewDelegate?
    var colorScheme: CaBColorScheme = .default

    private var id: ID?

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var menuButton: UIButton!

    func configure(for id: ID, with colorScheme: CaBColorScheme) {
        self.id = id
        self.colorScheme = colorScheme

        menuButton.setTitleColor(colorScheme.attributesTertiaryColor, for: .normal)
        backgroundColor = .white
        layer.cornerRadius = Constants.cornerRadius

        let menu: UIMenu
        let attributedTitle: NSAttributedString
        switch id {
        case .repeatMenu:
            let children: [UIAction] = makeSelectActions(for: MenuAction.repeatCases)
            menu = .init(title: "Repeat", options: .displayInline, children: children)
            attributedTitle = .init(string: "Repeat:",
                                    attributes: [
                                        .foregroundColor: colorScheme.highlightPrimaryColor,
                                        .font: Constants.font
                                    ])

        case .endDateMenu:
            let children: [UIAction] = makeSelectActions(for: MenuAction.endDateCases)
            menu = .init(title: "End date", options: .displayInline, children: children)
            attributedTitle = .init(string: "End date:",
                                    attributes: [
                                        .foregroundColor: colorScheme.highlightPrimaryColor,
                                        .font: Constants.font
                                    ])
        }

        titleLabel.attributedText = attributedTitle
        menuButton.menu = menu

        if #available(iOS 15.0, *) {
            menuButton.changesSelectionAsPrimaryAction = true
        } else {
            menuButton.showsMenuAsPrimaryAction = true
        }
    }

    func setItem(to menuAction: MenuAction) {
        let currentActions: [MenuAction]
        switch id {
        case .repeatMenu:
            currentActions = MenuAction.repeatCases

        case .endDateMenu:
            currentActions = MenuAction.endDateCases

        case .none:
            logError(message: "ID expected to be set")
            return
        }

        guard let index = currentActions.firstIndex(of: menuAction) else {
            logError(message: "Unknown action provided: \(menuAction)")
            return
        }

        let updatedChildren = makeSelectActions(for: rearrange(array: currentActions, fromIndex: index, toIndex: 0))
        menuButton.menu?.replacingChildren(updatedChildren)
    }

    private func makeSelectActions(for menuActions: [MenuAction]) -> [UIAction] {
        return menuActions.map { makeSelectAction(for: $0) }
    }

    private func makeSelectAction(for menuAction: MenuAction) -> UIAction {
        return UIAction(title: menuAction.title, image: menuAction.image) { [weak self] _ in
            if #available(iOS 15.0, *) {
                /* Do Nothing */
            } else {
                self?.menuButton.setTitle(menuAction.title, for: .normal)
            }
            self?.delegate?.didSelectAction(for: menuAction)
        }
    }

}

extension MenuAction {

    fileprivate var title: String {
        switch self {
        case .noRepeat:
            return "No repeat"

        case .daily:
            return "Daily"

        case .weekly:
            return "Weekly"

        case .monthly:
            return "Monthly"

        case .yearly:
            return "Yearly"

        case .concreteEndDate:
            return "Concrete"

        case .noEndDate:
            return "No end date"

        default:
            logError(message: "Unexpected case was provided: <\(rawValue)>")
            return ""
        }
    }

    fileprivate var image: UIImage? {
        switch self {
        case .noRepeat:
            return .MedicineChecker.noRepeat

        case .daily:
            return .MedicineChecker.dailyIcon

        case .weekly:
            return .MedicineChecker.weeklyIcon

        case .monthly:
            return .MedicineChecker.monthlyIcon

        case .yearly:
            return .MedicineChecker.yearlyIcon

        case .concreteEndDate,
             .noEndDate:
            return nil

        default:
            logError(message: "Unexpected case was provided: <\(rawValue)>")
            return nil
        }
    }

}

// MARK: - Repeat Menu Cases

extension MenuAction {

    static var repeatCases: [Self] {
        return [noRepeat, daily, weekly, monthly, yearly]
    }

    static var noRepeat: Self {
        return .init(rawValue: "noRepeat")
    }

    static var daily: Self {
        return .init(rawValue: "daily")
    }

    static var weekly: Self {
        return .init(rawValue: "weekly")
    }

    static var monthly: Self {
        return .init(rawValue: "monthly")
    }

    static var yearly: Self {
        return .init(rawValue: "yearly")
    }

}

// MARK: - End Date Menu Cases

extension MenuAction {

    static var endDateCases: [Self] {
        return [noEndDate, concreteEndDate]
    }

    static var noEndDate: Self {
        return .init(rawValue: "noEndDate")
    }

    static var concreteEndDate: Self {
        return .init(rawValue: "concrete")
    }

}

