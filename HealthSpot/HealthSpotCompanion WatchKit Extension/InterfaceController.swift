import WatchKit
import HealthKit

final class InterfaceController: WKInterfaceController {

    // MARK: - Internal Types

    enum ButtonState {
        case start
        case stop
    }

    // MARK: - Private Properties

    private var currentState: ButtonState = .start {
        didSet {
            switch currentState {
            case .start:
                actionButton.setTitle("Start")

            case .stop:
                actionButton.setTitle("Stop")
            }
        }
    }

    private var dataTracking: CompanionHealthDataTracking?
    private var connection: CompanionWatchKitConnection?

    @IBOutlet private weak var actionButton: WKInterfaceButton!
    @IBOutlet private weak var stepCountsLabel: WKInterfaceLabel!
    @IBOutlet private weak var heartRateLabel: WKInterfaceLabel!
    @IBOutlet private weak var calloriesCountLabel: WKInterfaceLabel!

    // MARK: - Internal Methods

    override func awake(withContext context: Any?) {
        configure()

        dataTracking?.authorizeHealthKit()
        dataTracking?.delegate = self
        connection?.startSession()
    }

    override func willActivate() {
        super.willActivate()

        dataTracking?.fetchCountableStatisticsData(.stepCount)
        dataTracking?.fetchCountableStatisticsData(.activeEnergyBurned)
    }
    
    override func didDeactivate() {
        super.didDeactivate()
    }

    // MARK: - Private Methods

    private func configure() {
        dataTracking = CompanionHealthDataTrackingImpl()
        connection = CompanionWatchKitConnectionImpl()
    }

    @IBAction private func tapActionButton() {
        switch currentState {
        case .start:
            dataTracking?.start()
            currentState = .stop

        case .stop:
            dataTracking?.start()
            currentState = .start
        }
        dataTracking?.start()
    }

}

// MARK: - Protocol CompanionHealthDataTrackingDelegate

extension InterfaceController: CompanionHealthDataTrackingDelegate {

    func didReceiveHealthKitHeartRate(_ heartRate: Double) {
        heartRateLabel.setText("\(Int(heartRate)) BPM")
        connection?.sendMessage(message: ["heartRate": "\(Int(heartRate))" as AnyObject], replyHandler: nil, errorHandler: nil)
    }

    func didReceiveHealthKitStepCounts(_ stepCounts: Double) {
        stepCountsLabel.setText("\(Int(stepCounts)) STEPS")
        connection?.sendMessage(message: ["stepsCount": "\(Int(stepCounts))" as AnyObject], replyHandler: nil, errorHandler: nil)
    }

    func didReceiveHealthKitBurntEnergy(_ burntEnergy: Double) {
        calloriesCountLabel.setText("\(Int(burntEnergy)) KCAL")
        connection?.sendMessage(message: ["burntEnergy": "\(Int(burntEnergy))" as AnyObject], replyHandler: nil, errorHandler: nil)
    }

}
