import UIKit
import CaBUIKit
import CaBFoundation

protocol ItemPeriodMenuViewDelegate: AnyObject {

    func didSelectItem(_ item: MenuItem)

}

struct MenuItem: RawRepresentable, Equatable, Hashable, Comparable {

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

    public static func <(lhs: MenuItem, rhs: MenuItem) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }

}

final class ParameterMenuTableViewCell: PeriodParameterContainerViewCell {
    
    // MARK: - Internal Types
    
    enum ID {
        case repeatMenu
        case endDateMenu
    }

    // MARK: - Private Types
    
    private enum Constants {

        static var font: UIFont {
            return CaBFont.Comfortaa.light(size: 12.0)
        }

        static var itemFont: UIFont {
            return CaBFont.Comfortaa.bold(size: 20.0)
        }

    }
    
    // MARK: - Internal Properties
    
    static var nib: UINib {
        return .init(nibName: cellIdentifier, bundle: .medicineChecker)
    }
    
    static var cellIdentifier: String {
        return "ParameterMenuTableViewCell"
    }

    weak var delegate: ItemPeriodMenuViewDelegate?
    var colorScheme: CaBColorScheme = .default

    // MARK: - Private Properties
    
    private var id: ID?
    @IBOutlet private weak var pickerView: UIPickerView!

    // MARK: - Internal Methods
    
    func configure(for id: ID, with colorScheme: CaBColorScheme) {
        self.id = id
        self.colorScheme = colorScheme

        pickerView.delegate = self
        pickerView.dataSource = self

        let attributedTitle: NSAttributedString
        switch id {
        case .repeatMenu:
            attributedTitle = .init(text: "Frequency",
                                    textColor: colorScheme.highlightPrimaryColor,
                                    font: Constants.font)

        case .endDateMenu:
            attributedTitle = .init(text: "Format",
                                    textColor: colorScheme.highlightPrimaryColor,
                                    font: Constants.font)
        }

        titleLabel.attributedText = attributedTitle
    }

    func setItem(to menuItem: MenuItem) {
        let currentActions: [MenuItem]
        switch id {
        case .repeatMenu:
            currentActions = MenuItem.repeatCases

        case .endDateMenu:
            currentActions = MenuItem.endDateCases

        case .none:
            logError(message: "ID expected to be set")
            return
        }

        let index = currentActions.firstIndex(of: menuItem) ?? 0
        pickerView.selectRow(index, inComponent: 0, animated: false)
    }
    
}

// MARK: - Protocol UIPickerViewDelegate

extension ParameterMenuTableViewCell: UIPickerViewDelegate {

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let currentItems: [MenuItem]
        switch id {
        case .repeatMenu:
            currentItems = MenuItem.repeatCases

        case .endDateMenu:
            currentItems = MenuItem.endDateCases

        case .none:
            logError(message: "ID expected to be set")
            return
        }

        delegate?.didSelectItem(currentItems[row])
    }

}

// MARK: - Protocol UIPickerViewDataSource

extension ParameterMenuTableViewCell: UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch id {
        case .repeatMenu:
            return MenuItem.repeatCases.count

        case .endDateMenu:
            return MenuItem.endDateCases.count

        default:
            logError(message: "ID expected to be set")
            return 0
        }
    }

    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel()

        let title: String
        switch id {
        case .repeatMenu:
            title = MenuItem.repeatCases[row].title

        case .endDateMenu:
            title = MenuItem.endDateCases[row].title

        default:
            logError(message: "ID expected to be set")
            title = ""
        }

        let attributedTitle = NSAttributedString(text: title,
                                                 textColor: colorScheme.highlightPrimaryColor,
                                                 font: Constants.itemFont)
        label.textAlignment = .center
        label.attributedText = attributedTitle

        return label
    }

}

// MARK: - Helpers

extension MenuItem {

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

// MARK: Repeat Menu Cases

extension MenuItem {

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

// MARK: End Date Menu Cases

extension MenuItem {

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
