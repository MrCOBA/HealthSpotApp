import UIKit
import CaBUIKit

final class MedicineListView: UIViewController {

    var colorScheme: CaBColorScheme = .default

    private var calendarPickerView: CalendarPickerView!
    @IBOutlet private weak var calendarContainerView: UIView!

    @IBOutlet private weak var medicineItemsListTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
    }

    private func configure() {
        configureCalendarPickerView()


    }

    private func configureCalendarPickerView() {
        calendarPickerView = CalendarPickerView(baseDate: Date(),
                                                colorScheme: colorScheme)
        calendarContainerView.addSubview(calendarPickerView)
        calendarPickerView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            calendarPickerView.leadingAnchor.constraint(equalTo: calendarContainerView.leadingAnchor),
            calendarPickerView.trailingAnchor.constraint(equalTo: calendarContainerView.trailingAnchor),
            calendarPickerView.topAnchor.constraint(equalTo: calendarContainerView.topAnchor),
            calendarPickerView.bottomAnchor.constraint(equalTo: calendarContainerView.bottomAnchor)
        ])
    }

}
