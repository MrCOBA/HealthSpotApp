import CaBFoundation
import CaBUIKit
import CaBFirebaseKit

public protocol MedicineCheckerRootServices: AnyObject {

    var colorScheme: CaBColorScheme { get }
    var coreDataAssistant: CoreDataAssistant { get }
    var medicineItemPeriodStorage: MedicineItemPeriodTemporaryStorage { get }
    var firebaseFirestoreMedicineCheckerController: FirebaseFirestoreMedicineCheckerController { get }
    var localNotificationsAssistant: LocalNotificationAssistant { get }

}
