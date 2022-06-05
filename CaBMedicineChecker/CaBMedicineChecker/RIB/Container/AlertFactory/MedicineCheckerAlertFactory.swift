import UIKit
import CaBFirebaseKit

public final class MedicineCheckerAlertFactory {

    // MARK: - Public Types

    public typealias AlertType = FirebaseFirestoreMedicineCheckerError

    // MARK: - Public Methods

    public func makeAlert(of type: AlertType) -> UIAlertController {
        let alert = UIAlertController(title: type.title, message: type.message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))

        return alert
    }

}

// MARK: - Helpers

extension MedicineCheckerAlertFactory.AlertType {

    fileprivate var title: String {
        switch self {
        case .failedToAddMedicineItemPeriod:
            return "An unexpected error has occured!"

        case .failedToDeleteMedicineItemPeriod:
            return "Failed to delete period..."

        case .failedToUpdateMedicineItemPeriod:
            return "Failed to update period..."

        case .failedToAddMedicineItem:
            return "An unexpected error has occured!"

        case .failedToUpdateData:
            return "Something going wrong..."

        case .failedToDeleteMedicineItem:
            return "Failed to delete medicine item..."

        default:
            return ""
        }
    }

    fileprivate var message: String {
        switch self {
        case .failedToAddMedicineItemPeriod:
            return "Failed to add new period..."

        case .failedToDeleteMedicineItemPeriod:
            return "An error occured during period deletion..."

        case .failedToUpdateMedicineItemPeriod:
            return "It was not possible to make changes now, try again later!"

        case .failedToAddMedicineItem:
            return "Failed to add new medicine item..."

        case .failedToUpdateData:
            return "Unable to update the data, try again later."

        case .failedToDeleteMedicineItem:
            return "An error occured during medicine item deletion..."

        default:
            return ""
        }
    }

}
