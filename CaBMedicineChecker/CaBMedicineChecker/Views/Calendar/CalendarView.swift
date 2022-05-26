import UIKit
import CaBUIKit
import CaBFoundation

protocol CalendarViewDelegate: AnyObject {

    func selectedDateChanged(to: Date)

}

final class CalendarView: XibView {

    // MARK: - Internal Types

    enum Mode {
        case large
        case small
    }

    // MARK: - Private Types

    private enum Constants {

        enum Fonts {

            static var fontSize: CGFloat {
                let smallDevice = UIScreen.main.bounds.width <= 350
                return smallDevice ? 14 : 17
            }
            
            static var titleFont: UIFont {
                return .init(name: "HelveticaNeue-Bold", size: 26.0)!
            }

            static var dayOfWeekFont: UIFont {
                return CaBFont.Comfortaa.bold(size: 12.0)
            }

            static var buttonFont: UIFont {
                return CaBFont.Comfortaa.medium(size: fontSize)
            }

        }

        enum Calendar {

            static var width: CGFloat {
                return UIScreen.main.bounds.width
            }

            static func height(numberOfWeaks: CGFloat) -> CGFloat {
                return ((width - 48) / 7) * numberOfWeaks
            }

        }

        static var cornerRadius: CGFloat {
            return 8.0
        }

    }

    // MARK: - Internal Properties

    override var bundle: Bundle? {
        return .medicineChecker
    }

    var colorScheme: CaBColorScheme = .default {
        didSet {
            configureView()
        }
    }

    weak var delegate: CalendarViewDelegate?

    private(set) var selectedDate = Date() {
        didSet {
            mode = .small
            collectionViewHeightConstraint.constant = Constants.Calendar.height(numberOfWeaks: 1.0)
            baseDate = selectedDate
        }
    }
    private(set) var baseDate = Date() {
        didSet {
            days = (mode == .small) ? generateDaysInWeek(for: baseDate) : generateDaysInMonth(for: baseDate)
            configureMonthLabel()
            configureDownButton()
            calendarCollectionView.reloadData()
        }
    }

    // MARK: - Private Properties

    private var mode: Mode = .small
    private let calendar = Calendar(identifier: .gregorian)
    private var days = [Day]()

    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var monthLabel: UILabel!
    @IBOutlet private weak var weekDayStackView: UIStackView!
    @IBOutlet private weak var calendarCollectionView: UICollectionView!
    @IBOutlet private weak var previousButton: UIButton!
    @IBOutlet private weak var nextButton: UIButton!
    @IBOutlet private weak var downButton: UIButton!

    @IBOutlet private var separatorViews: [UIView]!
    @IBOutlet private weak var collectionViewHeightConstraint: NSLayoutConstraint!

    // MARK: - Internal Methods

    override func configureView() {
        super.configureView()

        calendarCollectionView.dataSource = self
        calendarCollectionView.delegate = self
        
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = Constants.cornerRadius

        calendarCollectionView.register(CalendarDateCollectionViewCell.self,
                                        forCellWithReuseIdentifier: CalendarDateCollectionViewCell.cellIdentifier)

        configureMonthLabel()
        configureSeparatorViews()
        configureWeekDayStackView()
        configureNextButton()
        configurePreviousButton()
        configureDownButton()

        selectedDate = Date()
    }

    // MARK: - Private Methods

    private func configureMonthLabel() {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.locale = Locale.autoupdatingCurrent
        dateFormatter.setLocalizedDateFormatFromTemplate("MMMM y")

        let attributedMonth = NSAttributedString(text: dateFormatter.string(from: baseDate),
                                                 textColor: colorScheme.highlightPrimaryColor,
                                                 font: Constants.Fonts.titleFont)
        monthLabel.attributedText = attributedMonth
    }

    private func configureSeparatorViews() {
        separatorViews.forEach { $0.backgroundColor = .transparentGray20Alpha }
    }

    private func configureWeekDayStackView() {
        weekDayStackView.removeArrangedSubviews()

        weekDayStackView.distribution = .fillEqually

        for dayNumber in 1...7 {
            let dayLabel = UILabel()
            let attributedDay = NSAttributedString(text: dayOfWeekLetter(for: dayNumber),
                                                   textColor: colorScheme.highlightPrimaryColor,
                                                   font: Constants.Fonts.dayOfWeekFont)
            dayLabel.attributedText = attributedDay
            dayLabel.textAlignment = .center
            weekDayStackView.addArrangedSubview(dayLabel)
        }
    }

    private func configureNextButton() {
        nextButton.titleLabel?.font = Constants.Fonts.buttonFont
        nextButton.titleLabel?.textAlignment = .right

        if let chevronImage = UIImage(systemName: "chevron.right.circle.fill") {
            let imageAttachment = NSTextAttachment(image: chevronImage)
            let attributedString = NSMutableAttributedString(string: "Next ")

            attributedString.append(
                NSAttributedString(attachment: imageAttachment)
            )

            nextButton.setAttributedTitle(attributedString, for: .normal)
        }
        else {
            nextButton.setTitle("Next", for: .normal)
        }

        nextButton.titleLabel?.textColor = colorScheme.highlightPrimaryColor
    }

    private func configurePreviousButton() {
        previousButton.titleLabel?.font = Constants.Fonts.buttonFont
        previousButton.titleLabel?.textAlignment = .left

        if let chevronImage = UIImage(systemName: "chevron.left.circle.fill") {
            let imageAttachment = NSTextAttachment(image: chevronImage)
            let attributedString = NSMutableAttributedString()

            attributedString.append(
                NSAttributedString(attachment: imageAttachment)
            )

            attributedString.append(
                NSAttributedString(string: " Prev")
            )

            previousButton.setAttributedTitle(attributedString, for: .normal)
        }
        else {
            previousButton.setTitle("Prev", for: .normal)
        }

        previousButton.titleLabel?.textColor = colorScheme.highlightPrimaryColor
    }

    private func configureDownButton() {
        let image = (mode == .small)
        ? UIImage(systemName: "chevron.compact.down")
        : UIImage(systemName: "chevron.compact.up")
        downButton.setImage(image, for: .normal)
        downButton.tintColor = colorScheme.highlightPrimaryColor
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
    
    @IBAction func previousButtonPressed(_ sender: Any) {
        updateCalendar(with: -1)
    }

    @IBAction func nextButtonPressed(_ sender: Any) {
        updateCalendar(with: 1)
    }
    
    @IBAction func downButtonPressed(_ sender: Any) {
        mode = (mode == .small) ? .large : .small

        let numberOfWeeks = (mode == .small) ? 1 : (calendar.range(of: .weekOfMonth, in: .month, for: baseDate)?.count ?? 0)
        collectionViewHeightConstraint.constant = Constants.Calendar.height(numberOfWeaks: CGFloat(numberOfWeeks))
        baseDate = selectedDate
        layoutIfNeeded()
    }
    
}

// MARK: - Protocol UICollectionViewDataSource

extension CalendarView: UICollectionViewDataSource {

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

extension CalendarView: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let day = days[indexPath.row]

        selectedDate = day.date
        delegate?.selectedDateChanged(to: selectedDate)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = Constants.Calendar.height(numberOfWeaks: 1.0)
        let width = height
        return CGSize(width: width, height: height)
    }

}

// MARK: - Day Generation

extension CalendarView {

    fileprivate func generateDaysInMonth(for baseDate: Date) -> [Day] {
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

    fileprivate func generateDaysInWeek(for baseDate: Date) -> [Day] {
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

    fileprivate func monthMetadata(for baseDate: Date) -> MonthMetadata {
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

    fileprivate func generateDay(offsetBy dayOffset: Int, for baseDate: Date, isWithinDisplayedMonth: Bool) -> Day {
        let date = calendar.date(byAdding: .day, value: dayOffset, to: baseDate) ?? baseDate
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d"

        return Day(date: date,
                   number: Int(dateFormatter.string(from: date))!,
                   isSelected: calendar.isDate(date, inSameDayAs: selectedDate),
                   isWithinDisplayedMonth: isWithinDisplayedMonth
        )
    }

    fileprivate func generateStartOfNextMonth(using firstDayOfDisplayedMonth: Date) -> [Day] {
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

// MARK: - Helpers

extension CalendarView {

    private func dayOfWeekLetter(for dayNumber: Int) -> String {
        switch dayNumber {
        case 1:
            return "S"
        case 2:
            return "M"
        case 3:
            return "T"
        case 4:
            return "W"
        case 5:
            return "T"
        case 6:
            return "F"
        case 7:
            return "S"
        default:
            return ""
        }
    }

}
