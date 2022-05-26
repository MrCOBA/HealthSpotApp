import HealthKit
import CaBFoundation
import CaBMedicineChecker

protocol HealthDataTracking: AnyObject {
    func startObserveHeartRateSamples()
    func stopObserveHeartRateSamples()

    func startObserveStepsCountSamples()
    func stopObserveStepsCountSamples()
    
    func authorizeHealthKit()
}

final class HealthDataTrackingImpl: HealthDataTracking {

    // MARK: - Private Properties

    private let healthStore: HKHealthStore
    private var heartRateObserverQuery: HKObserverQuery!
    private var stepsCountObserverQuery: HKObserverQuery!

    private let statisticsStorage: HealthActivityStatisticsStorage

    // MARK: - Init

    init(statisticsStorage: HealthActivityStatisticsStorage) {
        self.healthStore = HKHealthStore()

        self.statisticsStorage = statisticsStorage
    }

    // MARK: - Public Methods

    func authorizeHealthKit() {
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

            healthStore.requestAuthorization(toShare: infoToShare, read: infoToRead) { (success, error) in
                if success {
                    logInfo(message: "Authorization healthkit success")
                }
                else if let error = error {
                    logWarning(message: "HealthKit authorization failed with error: <\(error.localizedDescription)>")
                }
            }
        }
        else {
            logInfo(message: "HealthKit not avaiable")
        }

    }

    func startObserveHeartRateSamples() {
        guard let heartRateSampleType = HKObjectType.quantityType(forIdentifier: .heartRate) else {
            return
        }

        if let heartRateObserverQuery = heartRateObserverQuery {
            healthStore.stop(heartRateObserverQuery)
        }

        heartRateObserverQuery = HKObserverQuery(sampleType: heartRateSampleType, predicate: nil) { [unowned self] (_, _, error) in
            if let error = error {
                logWarning(message: "Error was obtained: <\(error.localizedDescription)>")
                return
            }

            self.fetchLatestHeartRateSample { (sample) in
                guard let sample = sample else {
                    return
                }

                DispatchQueue.main.async { [weak self] in
                    let heartRateUnit = HKUnit.count().unitDivided(by: HKUnit.minute())
                    let heartRate = sample.quantity.doubleValue(for: heartRateUnit)
                    logInfo(message: "Heart Rate Sample: \(heartRate)")

                    self?.statisticsStorage.heartRate = heartRate
                }
            }
        }

        healthStore.execute(heartRateObserverQuery)
        healthStore.enableBackgroundDelivery(for: heartRateSampleType, frequency: .immediate) { (success, error) in
            if success {
                logInfo(message: "Success enable backgorund delivery <\(success)>")
            }
            if let error = error {
                logWarning(message: "Error was obtained: <\(error.localizedDescription)>")
            }
        }
    }

    func stopObserveHeartRateSamples() {
        if let heartRateObserverQuery = heartRateObserverQuery {
            healthStore.stop(heartRateObserverQuery)
        }
    }

    func startObserveStepsCountSamples() {
        guard let stepsCountSampleType = HKObjectType.quantityType(forIdentifier: .stepCount) else {
            return
        }

        if let stepsCountObserverQuery = stepsCountObserverQuery {
            healthStore.stop(stepsCountObserverQuery)
        }

        stepsCountObserverQuery = HKObserverQuery(sampleType: stepsCountSampleType, predicate: nil) { [unowned self] (_, _, error) in
            if let error = error {
                logWarning(message: "Error was obtained: <\(error.localizedDescription)>")
                return
            }

            self.fetchStepCountsStatisticsData { (stepsCount) in
                guard let stepsCount = stepsCount else {
                    return
                }
                logInfo(message: "Step Count Sample: \(stepsCount)")

                self.statisticsStorage.stepsCount = stepsCount
            }
        }

        healthStore.execute(stepsCountObserverQuery)
        healthStore.enableBackgroundDelivery(for: stepsCountSampleType, frequency: .hourly) { (success, error) in
            if success {
                logInfo(message: "Success enable backgorund delivery <\(success)>")
            }
            if let error = error {
                logWarning(message: "Error was obtained: <\(error.localizedDescription)>")
            }
        }
    }

    func stopObserveStepsCountSamples() {
        if let stepsCountObserverQuery = stepsCountObserverQuery {
            healthStore.stop(stepsCountObserverQuery)
        }
    }


    // MARK: - Private Methods

    private func fetchLatestHeartRateSample(completionHandler: @escaping (_ sample: HKQuantitySample?) -> Void) {
        guard let sampleType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate) else {
            completionHandler(nil)
            return
        }

        let predicate = HKQuery.predicateForSamples(withStart: Date.distantPast, end: Date(), options: .strictEndDate)
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        let query = HKSampleQuery(sampleType: sampleType,
                                  predicate: predicate,
                                  limit: Int(HKObjectQueryNoLimit),
                                  sortDescriptors: [sortDescriptor]) { (_, results, error) in
            if let error = error {
                logWarning(message: "Error was obtained: <\(error.localizedDescription)>")
                return
            }

            completionHandler(results?[0] as? HKQuantitySample)
        }

        healthStore.execute(query)
    }

    private func fetchStepCountsStatisticsData(completionHandler: @escaping (_ stepsCount: Double?) -> Void) {
        let stepsQuantityType = HKQuantityType.quantityType(forIdentifier: .stepCount)!

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
        ) { _, result, _ in
            guard let result = result, let sum = result.sumQuantity() else {
                completionHandler(0.0)
                return
            }
            completionHandler(sum.doubleValue(for: HKUnit.count()))
        }

        healthStore.execute(query)
    }


}
