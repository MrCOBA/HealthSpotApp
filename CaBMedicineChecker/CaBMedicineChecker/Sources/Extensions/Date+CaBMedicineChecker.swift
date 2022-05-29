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
        
        let distance = rawEvent.rawDate.distance(from: rawEpectedDate, only: rawEvent.frequency.calendarComponent)

        let newEvent = Calendar.current.date(byAdding: rawEvent.frequency.calendarComponent, value: distance, to: rawEpectedDate)

        return (newEvent == rawEvent.rawDate)
    }

}
