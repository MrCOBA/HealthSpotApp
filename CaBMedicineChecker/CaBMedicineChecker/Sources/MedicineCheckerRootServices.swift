import CaBFoundation
import CaBUIKit
import CaBFirebaseKit

public protocol HealthDataTracking: AnyObject {
    func observerHeartRateSamples()
    func authorizeHealthKit()
}

public protocol WatchKitConnectionDelegate: AnyObject {
    func didFinishedActiveSession()
}

public protocol WatchKitConnection: AnyObject{

    var delegate: WatchKitConnectionDelegate? { get set }

    func startSession()
    func sendMessage(message: [String : AnyObject], replyHandler: (([String : AnyObject]) -> Void)?, errorHandler: ((NSError) -> Void)?)

}


public protocol MedicineCheckerRootServices: AnyObject {

    var colorScheme: CaBColorScheme { get }
    var coreDataAssistant: CoreDataAssistant { get }
    var medicineItemPeriodStorage: MedicineItemPeriodTemporaryStorage { get }
    var firebaseFirestoreMedicineCheckerController: FirebaseFirestoreMedicineCheckerController { get }
    var localNotificationsAssistant: LocalNotificationAssistant { get }

    var dataTracking: HealthDataTracking { get }
    var watchKitConnection: WatchKitConnection { get }

}
