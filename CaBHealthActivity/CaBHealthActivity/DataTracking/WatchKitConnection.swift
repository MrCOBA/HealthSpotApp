import Foundation
import WatchConnectivity

// MARK: - Protocols

protocol WatchKitConnectionDelegate: AnyObject {
    func didFinishedActiveSession()
}

protocol WatchKitConnection: AnyObject{
    func startSession()
    func sendMessage(message: [String : AnyObject], replyHandler: (([String : AnyObject]) -> Void)?, errorHandler: ((NSError) -> Void)?)
}

// MARK: - Implementation

class WatchKitConnectionImpl: NSObject, WatchKitConnection {

    // MARK: - Internal Properties

    weak var delegate: WatchKitConnectionDelegate?

    // MARK: - Private Properties

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

    private override init() {
        super.init()
    }


    // MARK: - Internal Methods

    func startSession() {
        session?.delegate = self
        session?.activate()
    }

    func sendMessage(message: [String : AnyObject],
                     replyHandler: (([String : AnyObject]) -> Void)? = nil,
                     errorHandler: ((NSError) -> Void)? = nil)
    {
        validReachableSession?.sendMessage(message, replyHandler: { (result) in
            print(result)
        }, errorHandler: { (error) in
            print(error)
        })
    }

}

extension WatchKitConnectionImpl: WCSessionDelegate {

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("activationDidCompleteWith")
        delegate?.didFinishedActiveSession()
    }

    func sessionDidBecomeInactive(_ session: WCSession) {
        print("sessionDidBecomeInactive")
    }

    func sessionDidDeactivate(_ session: WCSession) {
        print("sessionDidDeactivate")
    }

    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        print("didReceiveMessage")
        print(message)
    }

    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        print("didReceiveMessage with reply")
        print(message)
        guard let heartReate = message.values.first as? String else {
            return
        }
        guard let heartReateDouble = Double(heartReate) else {
            return
        }
        LocalNotificationHelper.fireHeartRate(heartReateDouble)
    }

}
