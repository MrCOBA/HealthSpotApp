import UIKit
import CaBUIKit
import CaBSDK

extension UIStoryboard {

    struct MedicineItemInfoView: IdentifiableStoryboard {}
    struct MedicineItemPeriodView: IdentifiableStoryboard {}
    struct MedicineListView: IdentifiableStoryboard {}

}

// MARK: - MedicineItemInfoView

extension UIStoryboard.MedicineItemInfoView {

    public static var identifier: String {
        return "MedicineListView"
    }

    public static var bundle: Bundle {
        return .barcodeReader
    }

    static func instantiateAuthorizationViewController() -> MedicineItemInfoView {
        return instantiateViewController(withIdentifier: "MedicineItemInfoView")
    }

}

// MARK: - MedicineItemPeriodView

extension UIStoryboard.MedicineItemPeriodView {

    public static var identifier: String {
        return "MedicineListView"
    }

    public static var bundle: Bundle {
        return .barcodeReader
    }

    static func instantiateAuthorizationInfoViewController() -> MedicineItemPeriodView {
        return instantiateViewController(withIdentifier: "MedicineItemPeriodView")
    }

}

// MARK: - MedicineListView

extension UIStoryboard.MedicineListView {

    public static var identifier: String {
        return "MedicineListView"
    }

    public static var bundle: Bundle {
        return .barcodeReader
    }

    static func instantiateAuthorizationInfoViewController() -> MedicineListView {
        return instantiateViewController(withIdentifier: "MedicineListView")
    }

}
