import CaBFoundation
import WatchConnectivity
import CaBMedicineChecker

protocol WatchKitConnectionDelegate: AnyObject {
    func didFinishedActivateSession()
}

protocol WatchKitConnection: AnyObject{

    var delegate: WatchKitConnectionDelegate? { get set }

    func startSession()
    func sendMessage(message: [String : AnyObject], replyHandler: (([String : AnyObject]) -> Void)?, errorHandler: ((NSError) -> Void)?)

}

// MARK: - Implementation

class WatchKitConnectionImpl: NSObject, WatchKitConnection {

    // MARK: - Internal Properties

    weak var delegate: WatchKitConnectionDelegate?

    // MARK: - Private Properties

    private let statisticsStorage: HealthActivityStatisticsStorage
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

    init(statisticsStorage: HealthActivityStatisticsStorage) {
        self.statisticsStorage = statisticsStorage

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
                                           replyHandler: { (result) in print(result) },
                                           errorHandler: { (error) in print(error) })
    }

}

extension WatchKitConnectionImpl: WCSessionDelegate {

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        delegate?.didFinishedActivateSession()
    }

    func sessionDidBecomeInactive(_ session: WCSession) {
        /* Do Nothing */
    }

    func sessionDidDeactivate(_ session: WCSession) {
        /* Do Nothing */
    }

    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        /* Do Nothing */
    }

    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        guard let heartRate = message["heartRate"] as? String else {
            return
        }
        guard let heartRateDouble = Double(heartRate) else {
            return
        }

        statisticsStorage.heartRate = heartRateDouble

        guard let stepsCount = message["stepsCount"] as? String else {
            return
        }
        guard let stepsCount = Double(stepsCount) else {
            return
        }

        statisticsStorage.stepsCount = stepsCount
    }

}
