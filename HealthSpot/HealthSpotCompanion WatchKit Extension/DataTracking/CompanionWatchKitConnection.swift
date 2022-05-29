import WatchConnectivity

// MARK: - Protocols

protocol CompanionWatchKitConnectionDelegate: AnyObject {

    func didReceiveCommand(_ isOn: Bool)

}

protocol CompanionWatchKitConnection: AnyObject {

    var delegate: CompanionWatchKitConnectionDelegate? { get set }

    func startSession()
    func sendMessage(message: [String : AnyObject], replyHandler: (([String : AnyObject]) -> Void)?, errorHandler: ((NSError) -> Void)?)
}

// MARK: - Implementation

class CompanionWatchKitConnectionImpl: NSObject, CompanionWatchKitConnection {

    // MARK: - Internal Properties

    weak var delegate: CompanionWatchKitConnectionDelegate?

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

    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        guard let isOn = message.values.first as? Bool else {
            return
        }

        delegate?.didReceiveCommand(isOn)
    }

}
