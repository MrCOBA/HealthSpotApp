import UIKit
import CaBUIKit
import CaBFoundation

// MARK: - Delegate

protocol ItemPeriodDatePickerViewDelegate: AnyObject {

    func didChangeDate(for id: ParameterDatePickerTableViewCell.ID, to date: Date)

}

// MARK: - Cell

final class ParameterDatePickerTableViewCell: PeriodParameterContainerViewCell {

    // MARK: - Internal Types
    
    enum ID {
        case startDate
        case endDate
    }
    
    // MARK: - Private Types
    
    private enum Constants {

        static var font: UIFont {
            return CaBFont.Comfortaa.light(size: 12.0)
        }

    }
    
    // MARK: - Internal Properties
    
    static var nib: UINib {
        return .init(nibName: cellIdentifier, bundle: .medicineChecker)
    }
    
    static var cellIdentifier: String {
        return "ParameterDatePickerTableViewCell"
    }

    weak var delegate: ItemPeriodDatePickerViewDelegate?
    var colorScheme: CaBColorScheme = .default
    
    // MARK: - Private Properties
    
    @IBOutlet private weak var datePicker: UIDatePicker!
    private var id: ID?

    // MARK: - Internal Methods
    
    func configure(for id: ID, with colorScheme: CaBColorScheme) {
        self.id = id
        self.colorScheme = colorScheme

        datePicker.tintColor = colorScheme.highlightPrimaryColor
        
        let attributedTitle = NSAttributedString(text: "Date",
                                                 textColor: colorScheme.highlightPrimaryColor,
                                                 font: Constants.font)
        titleLabel.attributedText = attributedTitle
    }

    func setDate(_ date: Date) {
        datePicker.setDate(date, animated: false)
    }
    
    // MARK: - Private Methods

    @IBAction private func dateChanged(_ sender: Any) {
        guard let id = id else {
            logWarning(message: "ID expected to be set")
            return
        }
        delegate?.didChangeDate(for: id, to: datePicker.date)
    }
    
}
