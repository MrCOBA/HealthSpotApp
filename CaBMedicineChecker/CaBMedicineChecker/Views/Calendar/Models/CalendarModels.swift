import Foundation

struct MonthMetadata {

    let numberOfDays: Int
    let firstDay: Date
    let firstDayWeekday: Int

    static var empty: Self {
        return .init(numberOfDays: -1, firstDay: Date(), firstDayWeekday: -1)
    }

}

struct Day {

    let date: Date
    let number: Int
    let isSelected: Bool
    let isWithinDisplayedMonth: Bool

}
