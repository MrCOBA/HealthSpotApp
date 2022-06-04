
extension Date {

    public enum Frequency: String {
        case daily
        case weekly
        case monthly
        case yearly

        public var calendarComponent: Calendar.Component {
            switch self {
            case .daily:
                return .day

            case .weekly:
                return .weekOfYear

            case .monthly:
                return .month

            case .yearly:
                return .year
            }
        }
    }

    public func nextEventDate(startDate: Date, endDate: Date?, frequency: Frequency) -> Date? {
        let calendar = Calendar.current

        let components = calendar.dateComponents(Set(frequency.triggerDateComponents), from: startDate)

        var nextEventDate: Date?
        switch frequency {
        case .daily:
            nextEventDate = calendar.nextDate(after: self,
                                              matching: DateComponents(hour: components.hour, minute: components.minute),
                                              matchingPolicy: .nextTime)

        case .weekly:
            nextEventDate = calendar.nextDate(after: self,
                                              matching: DateComponents(hour: components.hour,
                                                                       minute: components.minute,
                                                                       weekday: components.weekday),
                                              matchingPolicy: .nextTime)


        case .monthly:
            nextEventDate = calendar.nextDate(after: self,
                                              matching: DateComponents(day: components.day,
                                                                       hour: components.hour,
                                                                       minute: components.minute),
                                              matchingPolicy: .nextTime)


        case .yearly:
            nextEventDate = calendar.nextDate(after: self,
                                              matching: DateComponents(month: components.month,
                                                                       day: components.day,
                                                                       hour: components.hour,
                                                                       minute: components.minute),
                                              matchingPolicy: .nextTime)
        }

        guard let endDate = endDate,
              let nextEventDate = nextEventDate
        else {
            return nextEventDate
        }

        return nextEventDate > endDate ? nil : nextEventDate
    }

    public func compare(with date: Date) -> Bool {
        let rawDate1 = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: self)!
        let rawDate2 = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: date)!

        return (rawDate1 == rawDate2)
    }

    public static func closestDate(from eventDates: [Date]) -> Date? {
        return (eventDates.count > 0) ? eventDates.sorted(by: { $0 < $1 }).first : nil
    }

    public func distance(from date: Date, only component: Calendar.Component, calendar: Calendar = .current) -> Int {
        let days1 = calendar.component(component, from: self)
        let days2 = calendar.component(component, from: date)
        return days1 - days2
    }

}
