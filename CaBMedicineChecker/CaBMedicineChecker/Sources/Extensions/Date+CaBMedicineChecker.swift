import CaBFoundation

extension Date {

    static func getRawEvents(from medicineItem: MedicineItemViewModel) -> [(rawDate: Date, frequency: Frequency)] {
        var rawEvents = [(rawDate: Date, frequency: Frequency)]()

        rawEvents = medicineItem.periods.map { period in
            let rawDate = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: period.startDate)!

            return (rawDate, period.frequency ?? .daily)
        }

        return rawEvents
    }

    static func isEventPossible(expectedDate: Date, rawEvent: (rawDate: Date, frequency: Frequency)) -> Bool {
        let rawEpectedDate = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: expectedDate)!

        guard rawEpectedDate >= rawEvent.rawDate else {
            return false
        }
        
        let distance: Int

        switch rawEvent.frequency {
        case.daily:
            distance = Calendar.current.dateComponents([rawEvent.frequency.calendarComponent],
                                                       from: rawEvent.rawDate,
                                                       to: rawEpectedDate).day ?? 0

        case .weekly:
            distance = Calendar.current.dateComponents([rawEvent.frequency.calendarComponent],
                                                       from: rawEvent.rawDate,
                                                       to: rawEpectedDate).weekOfYear ?? 0

        case .monthly:
            distance = Calendar.current.dateComponents([rawEvent.frequency.calendarComponent],
                                                       from: rawEvent.rawDate,
                                                       to: rawEpectedDate).month ?? 0

        case .yearly:
            distance = Calendar.current.dateComponents([rawEvent.frequency.calendarComponent],
                                                       from: rawEvent.rawDate,
                                                       to: rawEpectedDate).year ?? 0
        }


        let possibleEventDate = Calendar.current.date(byAdding: rawEvent.frequency.calendarComponent, value: distance, to: rawEvent.rawDate)

        return (rawEpectedDate == possibleEventDate)
    }

}
