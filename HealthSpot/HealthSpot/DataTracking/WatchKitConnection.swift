import CaBFoundation
import WatchConnectivity
import CaBMedicineChecker

// MARK: - Implementation

public class WatchKitConnectionImpl: NSObject, WatchKitConnection {

    // MARK: - Internal Properties

    public weak var delegate: WatchKitConnectionDelegate?

    // MARK: - Private Properties

    private let localNotificationsAssistant: LocalNotificationAssistant
    private let session: WCSession? = WCSession.isSupported() ? WCSession.default : nil

    private var validSession: WCSession? {
#if os(iOS)
        if let session = session, session.isPaired, session.isWatchAppInstalled {
            return session
        }
#elseif os(watchOS)
            return session
#endif
        return nil
    }

    private var validReachableSession: WCSession? {
        if let session = validSession, session.isReachable {
            return session
        }
        return nil
    }

    // MARK: - Init

    public init(localNotificationsAssistant: LocalNotificationAssistant) {
        self.localNotificationsAssistant = localNotificationsAssistant

        super.init()
    }

    // MARK: - Internal Methods

    public func startSession() {
        session?.delegate = self
        session?.activate()
    }

    public func sendMessage(message: [String : AnyObject],
                            replyHandler: (([String : AnyObject]) -> Void)? = nil,
                            errorHandler: ((NSError) -> Void)? = nil) {
        validReachableSession?.sendMessage(message,
                                           replyHandler: { (result) in print(result) },
                                           errorHandler: { (error) in print(error) })
    }

}

extension WatchKitConnectionImpl: WCSessionDelegate {

    public func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("activationDidCompleteWith")
        delegate?.didFinishedActiveSession()
    }

    public func sessionDidBecomeInactive(_ session: WCSession) {
        print("sessionDidBecomeInactive")
    }

    public func sessionDidDeactivate(_ session: WCSession) {
        print("sessionDidDeactivate")
    }

    public func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        print("didReceiveMessage")
        print(message)
    }

    public func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        print("didReceiveMessage with reply")
        print(message)
        guard let heartRate = message.values.first as? String else {
            return
        }
        guard let heartRateDouble = Double(heartRate) else {
            return
        }

        localNotificationsAssistant.push(notificationContent: .init(title: "Current heart rate",
                                                                    body: "Heart Reate = \(heartRateDouble)",
                                                                    category: "alarm",
                                                                    userInfo: ["customData": "fizzbuzz"]))
    }

}
