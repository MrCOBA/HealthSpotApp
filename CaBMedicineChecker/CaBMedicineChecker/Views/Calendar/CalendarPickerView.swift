import UIKit
import CaBUIKit
import CaBSDK

// MARK: - Delegate

protocol CalendarPickerViewDelegate: AnyObject {

    func selectedDateChanged(to date: Date)
    func calendarModeChanged()

}

final class CalendarPickerView: UIView {

    // MARK: - Internal Types

    enum Mode {
        case large
        case small
    }

    // MARK: - Private Types

    private enum Constants {

        static var cornerRadius: CGFloat {
            return 8.0
        }

        static func multiplier(for mode: Mode, numberOfWeeks: Double) -> CGFloat {
            switch mode {
            case .large:
                return CGFloat(numberOfWeeks/7.0)

            case .small:
                return CGFloat(1.0/7.0)
            }
        }

        static var headerHeight: CGFloat {
            return 85
        }

        static var footerHeight: CGFloat {
            return 60
        }

    }

    // MARK: - Internal Properties

    var colorScheme: CaBColorScheme = .default
    weak var delegate: CalendarPickerViewDelegate?

    // MARK: - Private Properties

    private var mode: Mode = .small {
        didSet {
            if oldValue != mode {
                //setHeightConstraint(for: mode)
                baseDate = selectedDate
            }
        }
    }

    private var selectedDate: Date = Date() {
        didSet {
            mode = .small
            baseDate = selectedDate
        }
    }

    private var baseDate: Date = Date() {
        didSet {
            days = (mode == .small) ? generateDaysInWeek(for: baseDate) : generateDaysInMonth(for: baseDate)
            collectionView.reloadData()
            headerView.baseDate = baseDate
        }
    }

    private var days = [Day]()
    private let calendar = Calendar(identifier: .gregorian)
    private var collectionViewHeightConstraint: NSLayoutConstraint?

    // MARK: Views

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isScrollEnabled = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    private lazy var headerView = CalendarPickerHeaderView(colorScheme: colorScheme)
    private lazy var footerView = CalendarPickerFooterView(colorScheme: colorScheme)

    // MARK: - Internal Methods

    override func awakeFromNib() {
        super.awakeFromNib()

        selectedDate = Date()

        configure()
    }

    // MARK: - Private Methods

    private func configure() {
        configureCollectionView()
        configureHeaderView()
        configureFooterView()
    }

    private func configureCollectionView() {
        collectionView.backgroundColor = .white
        addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])

        //setHeightConstraint(for: mode)

        collectionView.register(CalendarDateCollectionViewCell.self, forCellWithReuseIdentifier: CalendarDateCollectionViewCell.cellIdentifier)

        collectionView.dataSource = self
        collectionView.delegate = self
    }

    private func setHeightConstraint(for mode: Mode) {
        collectionViewHeightConstraint?.isActive = false
        let numberOfWeeks = calendar.range(of: .weekOfMonth, in: .month, for: baseDate)?.count ?? 0
        collectionViewHeightConstraint = collectionView.heightAnchor.constraint(equalTo: widthAnchor,
                                                                                multiplier: Constants.multiplier(for: mode, numberOfWeeks: Double(numberOfWeeks)))
        collectionViewHeightConstraint?.isActive = true
        layoutIfNeeded()
    }

    private func configureHeaderView() {
        addSubview(headerView)

        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: topAnchor),
            headerView.leadingAnchor.constraint(equalTo: collectionView.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: collectionView.trailingAnchor),
            headerView.bottomAnchor.constraint(equalTo: collectionView.topAnchor),
            headerView.heightAnchor.constraint(equalToConstant: Constants.headerHeight)
        ])

        headerView.baseDate = baseDate
        headerView.delegate = self
    }

    private func configureFooterView() {
        addSubview(footerView)

        NSLayoutConstraint.activate([
            footerView.leadingAnchor.constraint(equalTo: collectionView.leadingAnchor),
            footerView.trailingAnchor.constraint(equalTo: collectionView.trailingAnchor),
            footerView.topAnchor.constraint(equalTo: collectionView.bottomAnchor),
            footerView.heightAnchor.constraint(equalToConstant: Constants.footerHeight)
        ])

        footerView.delegate = self
    }

}

// MARK: - Day Generation

private extension CalendarPickerView {

    func generateDaysInMonth(for baseDate: Date) -> [Day] {
        let metadata = monthMetadata(for: baseDate)

        let numberOfDaysInMonth = metadata.numberOfDays
        let offsetInInitialRow = metadata.firstDayWeekday
        let firstDayOfMonth = metadata.firstDay

        var days: [Day] = (1..<(numberOfDaysInMonth + offsetInInitialRow)).map { day in
            let isWithinDisplayedMonth = day >= offsetInInitialRow
            let dayOffset = isWithinDisplayedMonth
            ? day - offsetInInitialRow
            : -(offsetInInitialRow - day)

            return generateDay(
                offsetBy: dayOffset,
                for: firstDayOfMonth,
                isWithinDisplayedMonth: isWithinDisplayedMonth)
        }

        days += generateStartOfNextMonth(using: firstDayOfMonth)

        return days
    }

    func generateDaysInWeek(for baseDate: Date) -> [Day] {
        let monthDays = generateDaysInMonth(for: baseDate)

        guard let dayIndex = monthDays.firstIndex(where: { $0.date.hasSame(.day, as: baseDate) }) else {
            logError(message: "Day must be included in the month days")
            return []
        }

        let div = dayIndex % 7

        let firstWeekDayIndex = dayIndex - div
        let lastWeekDayIndex = dayIndex + (6 - div)

        let weekDays = Array(monthDays[firstWeekDayIndex...lastWeekDayIndex])

        return weekDays
    }

    func monthMetadata(for baseDate: Date) -> MonthMetadata {
        guard let numberOfDaysInMonth = calendar.range(of: .day, in: .month, for: baseDate)?.count,
              let firstDayOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: baseDate))
        else {
            logError(message: "Failed to generate month metadata")
            return .empty
        }

        let firstDayWeekday = calendar.component(.weekday, from: firstDayOfMonth)

        return MonthMetadata(numberOfDays: numberOfDaysInMonth,
                             firstDay: firstDayOfMonth,
                             firstDayWeekday: firstDayWeekday)
    }

    func generateDay(offsetBy dayOffset: Int, for baseDate: Date, isWithinDisplayedMonth: Bool) -> Day {
        let date = calendar.date(byAdding: .day, value: dayOffset, to: baseDate) ?? baseDate
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d"

        return Day(date: date,
                   number: Int(dateFormatter.string(from: date))!,
                   isSelected: calendar.isDate(date, inSameDayAs: selectedDate),
                   isWithinDisplayedMonth: isWithinDisplayedMonth
        )
    }

    func generateStartOfNextMonth(using firstDayOfDisplayedMonth: Date) -> [Day] {
        guard let lastDayInMonth = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: firstDayOfDisplayedMonth)
        else {
            return []
        }

        let additionalDays = 7 - calendar.component(.weekday, from: lastDayInMonth)
        guard additionalDays > 0 else {
            return []
        }

        let days: [Day] = (1...additionalDays).map { generateDay(offsetBy: $0, for: lastDayInMonth, isWithinDisplayedMonth: false) }

        return days
    }

}

// MARK: - Protocol UICollectionViewDataSource

extension CalendarPickerView: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        days.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let day = days[indexPath.row]

        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CalendarDateCollectionViewCell.cellIdentifier,
            for: indexPath) as! CalendarDateCollectionViewCell

        cell.day = day
        return cell
    }
    
}

// MARK: - Protocol UICollectionViewDelegateFlowLayout

extension CalendarPickerView: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let day = days[indexPath.row]

        selectedDate = day.date
        delegate?.selectedDateChanged(to: selectedDate)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = Int(collectionView.frame.width / 7)
        let height = width
        return CGSize(width: width, height: height)
    }

}

// MARK: - Protocol CalendarPickerFooterDelegate

extension CalendarPickerView: CalendarPickerFooterDelegate {

    func didTapPreviousMonthButton() {
        updateCalendar(with: -1)
    }

    func didTapNextMonthButton() {
        updateCalendar(with: 1)
    }

    private func updateCalendar(with value: Int) {
        let newDate: Date
        switch mode {
        case .small:
            newDate = calendar.date(byAdding: .weekOfYear, value: value, to: baseDate) ?? baseDate

        case .large:
            newDate = calendar.date(byAdding: .month, value: value, to: baseDate) ?? baseDate
        }

        baseDate = newDate
    }

}

// MARK: - Protocol CalendarPickerHeaderDelegate

extension CalendarPickerView: CalendarPickerHeaderDelegate {

    func didTapHeaderView() {
        mode = .large
    }
    
}
