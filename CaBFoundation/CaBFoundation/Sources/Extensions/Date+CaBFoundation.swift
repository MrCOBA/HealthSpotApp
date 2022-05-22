
extension Date {

    public enum Frequency: String {
        case daily
        case weekly
        case monthly
        case yearly

        var calendarComponent: Calendar.Component {
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

    public func nextEventDate(_ endDate: Date?, frequency: Frequency) -> Date? {
        let calendar = Calendar.current
        let dateComponents = Set([frequency.calendarComponent])

        let difDateComponents = calendar.dateComponents(dateComponents, from: self, to: Date())

        let nextEventDate: Date
        switch frequency {
        case .daily:
            let components = DateComponents(day: (difDateComponents.day ?? 0) + 1)
            nextEventDate = calendar.date(byAdding: components, to: self) ?? Date()

        case .weekly:
            let components = DateComponents(weekOfYear: (difDateComponents.weekOfYear ?? 0) + 1)
            nextEventDate = calendar.date(byAdding: components, to: self) ?? Date()

        case .monthly:
            let components = DateComponents(month: (difDateComponents.month ?? 0) + 1)
            nextEventDate = calendar.date(byAdding: components, to: self) ?? Date()

        case .yearly:
            let components = DateComponents(year: (difDateComponents.year ?? 0) + 1)
            nextEventDate = calendar.date(byAdding: components, to: self) ?? Date()
        }

        var resultDate: Date?
        if let endDate = endDate {
            resultDate = endDate > nextEventDate ? nextEventDate : nil
        }
        else {
            resultDate = nextEventDate
        }

        return resultDate
    }

    public func hasSame(_ component: Calendar.Component, as date: Date) -> Bool {
        distance(from: date, only: component) == 0
    }

    public static func closestDate(from eventDates: [Date]) -> Date? {
        return (eventDates.count > 0) ? eventDates.sorted(by: { $0 < $1 }).first : nil
    }

}

// MARK: - Helper

extension Date {

    private func distance(from date: Date, only component: Calendar.Component, calendar: Calendar = .current) -> Int {
        let days1 = calendar.component(component, from: self)
        let days2 = calendar.component(component, from: date)
        return days1 - days2
    }

}
