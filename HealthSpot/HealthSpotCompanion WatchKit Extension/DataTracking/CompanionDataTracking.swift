import Foundation
import HealthKit

protocol CompanionDataTrackingDelegate: AnyObject {

    func didReceiveHealthKitHeartRate(_ heartRate: Double)
    func didReceiveHealthKitStepCounts(_ stepCounts: Double)

}

protocol CompanionDataTracking: AnyObject {
    func start()
    func stop()
}

final class CompanionDataTrackingImpl: NSObject, CompanionDataTracking {

    // MARK: - Internal Properties

    weak var delegate: CompanionDataTrackingDelegate?

    let healthStore: HKHealthStore
    let configuration: HKWorkoutConfiguration

    var session: HKWorkoutSession!
    var builder: HKLiveWorkoutBuilder!

    // MARK: - Init

    override init() {
        healthStore = HKHealthStore()
        configuration = HKWorkoutConfiguration()
        super.init()
    }

    // MARK: - Internal Methods

    static func authorizeHealthKit() {
        if HKHealthStore.isHealthDataAvailable() {
            let infoToRead = Set([
                HKSampleType.quantityType(forIdentifier: .stepCount)!,
                HKSampleType.quantityType(forIdentifier: .heartRate)!,
                HKSampleType.workoutType()
                ])

            let infoToShare = Set([
                HKSampleType.quantityType(forIdentifier: .stepCount)!,
                HKSampleType.quantityType(forIdentifier: .heartRate)!,
                HKSampleType.workoutType()
                ])

            HKHealthStore().requestAuthorization(toShare: infoToShare, read: infoToRead) { (success, error) in
                if success {
                    print("Authorization healthkit success")
                }
                else if let error = error {
                    print(error)
                }
            }
        } else {
            print("HealthKit not avaiable")
        }
    }

    func start() {
        configure()
        session.startActivity(with: Date())
        builder.beginCollection(withStart: Date()) { (success, error) in
            if success {
                NSLog("$@", "Success data tracking initialization <\(success)>")
            }
            if let error = error {
                NSLog("%@", "Error was obtained: <\(error.localizedDescription)>")
            }
        }
    }

    func stop() {
        session.stopActivity(with: Date())
        session.end()
        builder.endCollection(withEnd: Date()) { (success, error) in
            if success {
                NSLog("$@", "Success data tracking deinitialization <\(success)>")
            }
            if let error = error {
                NSLog("%@", "Error was obtained: <\(error.localizedDescription)>")
            }
        }
    }

    // MARK: - Private Methods

    private func configure() {
        configuration.activityType = .walking

        do {
            session = try HKWorkoutSession(healthStore: healthStore, configuration: configuration)
            builder = session?.associatedWorkoutBuilder()
        }
        catch {
            NSLog("%@", "Error was obtained: <\(error.localizedDescription)>")
            return
        }

        session.delegate = self
        builder.delegate = self

        builder.dataSource = HKLiveWorkoutDataSource(healthStore: healthStore, workoutConfiguration: configuration)
    }

    private func handleSendStatisticsData(_ statistics: HKStatistics) {
        switch statistics.quantityType {
        case HKQuantityType.quantityType(forIdentifier: .heartRate):
            handleHeartRateStatisticsData(statistics)

        case HKQuantityType.quantityType(forIdentifier: .stepCount):
            handleStepCountsStatisticsData()

        default:
            return
        }
    }

    private func handleHeartRateStatisticsData(_ statistics: HKStatistics) {
        let heartRateUnit = HKUnit.count().unitDivided(by: HKUnit.minute())
        let value = statistics.mostRecentQuantity()?.doubleValue(for: heartRateUnit)
        let roundedValue = Double( round( 1 * value! ) / 1 )
        delegate?.didReceiveHealthKitHeartRate(roundedValue)
    }

    private func handleStepCountsStatisticsData() {
        guard let stepCounts = HKQuantityType.quantityType(forIdentifier: .stepCount) else {
            return
        }
        let startOfDay = Calendar.current.startOfDay(for: Date())
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: Date(), options: .strictStartDate)

        let query = HKStatisticsQuery(quantityType: stepCounts,
                                      quantitySamplePredicate: predicate,
                                      options: .cumulativeSum) { [weak self] (_, result, error) in
            guard let this = self else {
                return
            }

            var resultCount = 0.0
            guard let result = result else {
                print("Failed to fetch steps rate <1>")
                return
            }

            if let sum = result.sumQuantity() {
                resultCount = sum.doubleValue(for: HKUnit.count())
                this.delegate?.didReceiveHealthKitStepCounts(resultCount)
            }
            else {
                print("Failed to fetch steps rate <2>")
            }
        }
        healthStore.execute(query)
    }

}

// MARK: - Protocol HKLiveWorkoutBuilderDelegate

extension CompanionDataTrackingImpl: HKLiveWorkoutBuilderDelegate {

    func workoutBuilder(_ workoutBuilder: HKLiveWorkoutBuilder, didCollectDataOf collectedTypes: Set<HKSampleType>) {
        NSLog("%@", "Start data receiving: <\(Date())>")
        for type in collectedTypes {
            guard let quantityType = type as? HKQuantityType else {
                return
            }

            if let statistics = workoutBuilder.statistics(for: quantityType) {
                handleSendStatisticsData(statistics)
            }
        }
    }

    func workoutBuilderDidCollectEvent(_ workoutBuilder: HKLiveWorkoutBuilder) {
        /* Do Nothing */
    }

}

extension CompanionDataTrackingImpl: HKWorkoutSessionDelegate {

    func workoutSession(_ workoutSession: HKWorkoutSession, didChangeTo toState: HKWorkoutSessionState, from fromState: HKWorkoutSessionState, date: Date) {
        /* Do Nothing */
    }

    func workoutSession(_ workoutSession: HKWorkoutSession, didFailWithError error: Error) {
        /* Do Nothing */
    }

}
