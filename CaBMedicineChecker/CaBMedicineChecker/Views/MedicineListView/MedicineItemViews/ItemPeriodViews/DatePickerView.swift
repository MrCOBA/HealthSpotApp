import UIKit
import CaBSDK
import CaBUIKit

protocol ItemPeriodDatePickerViewDelegate: AnyObject {

    func didChangeDate(for id: ItemPeriodDatePickerView.ID, to date: Date)

}

final class ItemPeriodDatePickerView: UIView {

    enum ID {
        case startDate
        case endDate
    }

    private enum Constants {

        static var cornerRadius: CGFloat {
            return 8.0
        }

        static var font: UIFont {
            return CaBFont.Comfortaa.medium(size: 17.0)
        }

    }

    weak var delegate: ItemPeriodDatePickerViewDelegate?
    var colorScheme: CaBColorScheme = .default

    private var id: ID?

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var datePicker: UIDatePicker!

    func configure(for id: ID, with colorScheme: CaBColorScheme) {
        self.id = id
        self.colorScheme = colorScheme

        datePicker.tintColor = colorScheme.highlightPrimaryColor
        backgroundColor = .white
        layer.cornerRadius = Constants.cornerRadius

        let attributedTitle: NSAttributedString
        switch id {
        case .startDate:
            attributedTitle = .init(string: "Start date:",
                                    attributes: [
                                        .foregroundColor: colorScheme.highlightPrimaryColor,
                                        .font: Constants.font
                                    ])

        case .endDate:
            attributedTitle = .init(string: "End date:",
                                    attributes: [
                                        .foregroundColor: colorScheme.highlightPrimaryColor,
                                        .font: Constants.font
                                    ])
        }

        titleLabel.attributedText = attributedTitle
    }

    func setDate(_ date: Date) {
        datePicker.setDate(date, animated: false)
    }

    @IBAction private func dateChanged(_ sender: Any) {
        guard let id = id else {
            logWarning(message: "ID expected to be set")
            return
        }
        delegate?.didChangeDate(for: id, to: datePicker.date)
    }

}
