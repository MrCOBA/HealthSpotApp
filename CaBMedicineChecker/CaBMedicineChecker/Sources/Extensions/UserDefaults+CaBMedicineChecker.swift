import CaBFoundation

extension UserDefaults.Key {

    enum MedicineChecker {

        static var id: String {
            return "MedicineCheckerTemporaryId"
        }

        static var startDate: String {
            return "MedicineCheckerTemporaryStartDate"
        }

        static var endDate: String {
            return "MedicineCheckerTemporaryEndDate"
        }

        static var frequency: String {
            return "MedicineCheckerTemporaryFrequency"
        }

        static var notificationHint: String {
            return "MedicineCheckerTemporaryNotificationHint"
        }

    }

}
