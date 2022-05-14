import CaBSDK

extension UserDefaults.Key {

    enum MedicineChecker {

        static var startDate: String {
            return "MedicineCheckerTemporaryStartDate"
        }

        static var endDate: String {
            return "MedicineCheckerTemporaryEndDate"
        }

        static var repeatType: String {
            return "MedicineCheckerTemporaryRepeatType"
        }

        static var notificationHint: String {
            return "MedicineCheckerTemporaryNotificationHint"
        }

    }

}
