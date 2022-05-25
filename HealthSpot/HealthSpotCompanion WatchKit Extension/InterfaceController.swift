import WatchKit
import HealthKit

final class InterfaceController: WKInterfaceController {

    // MARK: - Private Properties

    private var dataTracking: CompanionHealthDataTracking?
    private var connection: CompanionWatchKitConnection?

    @IBOutlet private weak var userNameLabel: WKInterfaceLabel!
    @IBOutlet private weak var stepCountsLabel: WKInterfaceLabel!
    @IBOutlet private weak var heartRateLabel: WKInterfaceLabel!

    // MARK: - Internal Methods

    override func awake(withContext context: Any?) {
        configure()

        dataTracking?.authorizeHealthKit()
        dataTracking?.delegate = self
        connection?.startSession()
    }

    override func willActivate() {
        super.willActivate()

        dataTracking?.fetchStepCountsStatisticsData()
    }
    
    override func didDeactivate() {
        super.didDeactivate()
    }

    // MARK: - Private Methods

    private func configure() {
        dataTracking = CompanionHealthDataTrackingImpl()
        connection = CompanionWatchKitConnectionImpl()
    }

    @IBAction private func startButtonTapped() {
        dataTracking?.start()
    }

    @IBAction private func stopButtonTapped() {
        dataTracking?.stop()
    }

}

// MARK: - Protocol CompanionHealthDataTrackingDelegate

extension InterfaceController: CompanionHealthDataTrackingDelegate {

    func didReceiveHealthKitHeartRate(_ heartRate: Double) {
        heartRateLabel.setText("\(heartRate) BPM")
        connection?.sendMessage(message: ["heartRate": "\(heartRate)" as AnyObject], replyHandler: nil, errorHandler: nil)
    }

    func didReceiveHealthKitStepCounts(_ stepCounts: Double) {
        stepCountsLabel.setText("\(stepCounts) STEPS")
    }

}

// MARK: - Protocol CompanionWatchKitConnectionDelegate

extension InterfaceController: CompanionWatchKitConnectionDelegate {

    func didReceiveUserName(_ userName: String) {
        userNameLabel.setText(userName)
    }

}
