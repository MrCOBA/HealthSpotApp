import CaBSDK
import CaBUIKit

public protocol MedicineCheckerRootServices: AnyObject {

    var colorScheme: CaBColorScheme { get }
    var coreDataAssistant: CoreDataAssistant { get }
    var medicineItemPeriodStorage: MedicineItemPeriodTemporaryStorage { get }

}
