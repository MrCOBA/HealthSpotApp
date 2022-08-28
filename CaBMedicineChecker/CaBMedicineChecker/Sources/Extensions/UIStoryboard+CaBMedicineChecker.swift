import UIKit
import CaBUIKit
import CaBFoundation

extension UIStoryboard {

    struct MedicineItemInfoView: IdentifiableStoryboard {}
    struct MedicineItemPeriodViewLegacy: IdentifiableStoryboard {}
    struct MedicineItemPeriodView: IdentifiableStoryboard {}
    struct MedicineListView: IdentifiableStoryboard {}
    struct BarcodeCaptureView: IdentifiableStoryboard {}

}

// MARK: - MedicineItemInfoView

extension UIStoryboard.MedicineItemInfoView {

    public static var identifier: String {
        return "MedicineListView"
    }

    public static var bundle: Bundle {
        return .medicineChecker
    }

    static func instantiateMedicineItemInfoViewController() -> MedicineItemInfoView {
        return instantiateViewController(withIdentifier: "MedicineItemInfoView")
    }

}

// MARK: - MedicineItemPeriodViewLegacy

extension UIStoryboard.MedicineItemPeriodViewLegacy {

    public static var identifier: String {
        return "MedicineListView"
    }

    public static var bundle: Bundle {
        return .medicineChecker
    }

    static func instantiateMedicineItemPeriodViewController() -> MedicineItemPeriodViewLegacy {
        return instantiateViewController(withIdentifier: "MedicineItemPeriodViewLegacy")
    }

}

// MARK: - MedicineItemPeriodView

extension UIStoryboard.MedicineItemPeriodView {

    public static var identifier: String {
        return "MedicineListView"
    }

    public static var bundle: Bundle {
        return .medicineChecker
    }

    static func instantiateMedicineItemPeriodViewController() -> MedicineItemPeriodView {
        return instantiateViewController(withIdentifier: "MedicineItemPeriodView")
    }

}

// MARK: - MedicineListView

extension UIStoryboard.MedicineListView {

    public static var identifier: String {
        return "MedicineListView"
    }

    public static var bundle: Bundle {
        return .medicineChecker
    }

    static func instantiateMedicineListViewController() -> MedicineListView {
        return instantiateViewController(withIdentifier: "MedicineListView")
    }

}

// MARK: - BarcodeCaptureView

extension UIStoryboard.BarcodeCaptureView {

    public static var identifier: String {
        return "BarcodeCaptureView"
    }

    public static var bundle: Bundle {
        return .medicineChecker
    }

    static func instantiateBarcodeCaptureViewController() -> BarcodeCaptureView {
        return instantiateViewController(withIdentifier: "BarcodeCaptureView")
    }

}
