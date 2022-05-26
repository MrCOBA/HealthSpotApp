import Foundation
import HealthKit

// MARK: - Protocols

protocol CompanionHealthDataTrackingDelegate: AnyObject {
    func didReceiveHealthKitHeartRate(_ heartRate: Double)
    func didReceiveHealthKitStepCounts(_ stepCounts: Double)
    func didReceiveHealthKitBurntEnergy(_ burntEnergy: Double)
}

protocol CompanionHealthDataTracking: AnyObject {

    var delegate: CompanionHealthDataTrackingDelegate? { get set }

    func authorizeHealthKit()
    func start()
    func stop()

    func fetchCountableStatisticsData(_ identifier: HKQuantityTypeIdentifier)
    func fetchHeartRateStatisticsData(_ statistics: HKStatistics)
}

// MARK: - Implementation

final class CompanionHealthDataTrackingImpl: NSObject, CompanionHealthDataTracking {

    // MARK: - Internal Properties

    weak var delegate: CompanionHealthDataTrackingDelegate?

    // MARK: - Private Properties

    private let healthStore: HKHealthStore
    private let configuration: HKWorkoutConfiguration

    private var session: HKWorkoutSession!
    private var builder: HKLiveWorkoutBuilder!

    // MARK: - Init

    override init() {
        healthStore = HKHealthStore()
        configuration = HKWorkoutConfiguration()
        super.init()
    }

    // MARK: - Internal Methods

    func authorizeHealthKit() {
        if HKHealthStore.isHealthDataAvailable() {
            let infoToRead = Set([
                HKSampleType.quantityType(forIdentifier: .stepCount)!,
                HKSampleType.quantityType(forIdentifier: .heartRate)!,
                HKSampleType.quantityType(forIdentifier: .activeEnergyBurned)!,
                HKSampleType.workoutType()
                ])

            let infoToShare = Set([
                HKSampleType.quantityType(forIdentifier: .stepCount)!,
                HKSampleType.quantityType(forIdentifier: .heartRate)!,
                HKSampleType.quantityType(forIdentifier: .activeEnergyBurned)!,
                HKSampleType.workoutType()
                ])

            HKHealthStore().requestAuthorization(toShare: infoToShare, read: infoToRead) { (success, error) in
                if success {
                    NSLog("Authorization healthkit success")
                }
                else if let error = error {
                    NSLog("Error was obtained: <\(error.localizedDescription)>")
                }
            }
        } else {
            NSLog("HealthKit not avaiable")
        }
    }

    func start() {
        configure()
        session.startActivity(with: Date())
        builder.beginCollection(withStart: Date()) { (success, error) in
            if success {
                NSLog("Success data tracking initialization <\(success)>")
            }
            if let error = error {
                NSLog("Error was obtained: <\(error.localizedDescription)>")
            }
        }
    }

    func stop() {
        session.stopActivity(with: Date())
        session.end()
        builder.endCollection(withEnd: Date()) { (success, error) in
            if success {
                NSLog("Success data tracking deinitialization <\(success)>")
            }
            if let error = error {
                NSLog("Error was obtained: <\(error.localizedDescription)>")
            }
        }
    }

    func fetchCountableStatisticsData(_ identifier: HKQuantityTypeIdentifier) {
        let stepsQuantityType = HKQuantityType.quantityType(forIdentifier: identifier)!

        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(
            withStart: startOfDay,
            end: now,
            options: .strictStartDate
        )

        let query = HKStatisticsQuery(
            quantityType: stepsQuantityType,
            quantitySamplePredicate: predicate,
            options: .cumulativeSum
        ) { [weak self] (_, result, _) in
            guard let result = result, let sum = result.sumQuantity() else {
                switch identifier {
                case .stepCount:
                    self?.delegate?.didReceiveHealthKitStepCounts(0.0)

                case .activeEnergyBurned:
                    self?.delegate?.didReceiveHealthKitBurntEnergy(0.0)

                default:
                    return
                }

                return
            }

            switch identifier {
            case .stepCount:
                self?.delegate?.didReceiveHealthKitStepCounts(sum.doubleValue(for: HKUnit.count()))

            case .activeEnergyBurned:
                self?.delegate?.didReceiveHealthKitBurntEnergy(sum.doubleValue(for: HKUnit.kilocalorie()))

            default:
                return
            }
        }

        healthStore.execute(query)
    }

    func fetchHeartRateStatisticsData(_ statistics: HKStatistics) {
        let heartRateUnit = HKUnit.count().unitDivided(by: HKUnit.minute())
        let value = statistics.mostRecentQuantity()?.doubleValue(for: heartRateUnit)
        let roundedValue = Double( round( 1 * value! ) / 1 )
        delegate?.didReceiveHealthKitHeartRate(roundedValue)
    }

    // MARK: - Private Methods

    private func configure() {
        configuration.activityType = .walking

        do {
            session = try HKWorkoutSession(healthStore: healthStore, configuration: configuration)
            builder = session?.associatedWorkoutBuilder()
        }
        catch {
            NSLog("Error was obtained: <\(error.localizedDescription)>")
            return
        }

        builder.delegate = self
        builder.dataSource = HKLiveWorkoutDataSource(healthStore: healthStore, workoutConfiguration: configuration)
    }

    private func handleSendStatisticsData(_ statistics: HKStatistics) {
        switch statistics.quantityType {
        case HKQuantityType.quantityType(forIdentifier: .heartRate):
            fetchHeartRateStatisticsData(statistics)

        case HKQuantityType.quantityType(forIdentifier: .stepCount):
            fetchCountableStatisticsData(.stepCount)

        case HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned):
            fetchCountableStatisticsData(.activeEnergyBurned)

        default:
            return
        }
    }

}

// MARK: - Protocol HKLiveWorkoutBuilderDelegate

extension CompanionHealthDataTrackingImpl: HKLiveWorkoutBuilderDelegate {

    func workoutBuilder(_ workoutBuilder: HKLiveWorkoutBuilder, didCollectDataOf collectedTypes: Set<HKSampleType>) {
        NSLog("Start data receiving: <\(Date())>")
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
