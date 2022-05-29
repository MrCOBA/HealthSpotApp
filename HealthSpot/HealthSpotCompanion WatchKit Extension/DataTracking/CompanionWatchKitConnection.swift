import WatchConnectivity

// MARK: - Protocols

protocol CompanionWatchKitConnection: AnyObject {
    func startSession()
    func sendMessage(message: [String : AnyObject], replyHandler: (([String : AnyObject]) -> Void)?, errorHandler: ((NSError) -> Void)?)
}

// MARK: - Implementation

class CompanionWatchKitConnectionImpl: NSObject, CompanionWatchKitConnection {

    // MARK: - Private Properties

    private let session: WCSession?

    private var validSession: WCSession? {
#if os(iOS)
        if let session = session, session.isPaired, session.isWatchAppInstalled {
            return session
        }
#elseif os(watchOS)
        return session
#endif
    }

    private var validReachableSession: WCSession? {
        if let session = validSession, session.isReachable {
            return session
        }
        return nil
    }

    // MARK: - Init

    override init() {
        session = WCSession.isSupported() ? WCSession.default : nil

        super.init()
    }

    // MARK: - Internal Methods

    func startSession() {
        session?.delegate = self
        session?.activate()
    }

    func sendMessage(message: [String : AnyObject],
                     replyHandler: (([String : AnyObject]) -> Void)? = nil,
                     errorHandler: ((NSError) -> Void)? = nil) {
        validReachableSession?.sendMessage(message,
                                           replyHandler: { (result) in NSLog("\(result)") },
                                           errorHandler: { (error) in NSLog("\(error)") })
    }

}

extension CompanionWatchKitConnectionImpl: WCSessionDelegate {

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        /* Do Nothin */
    }

}
