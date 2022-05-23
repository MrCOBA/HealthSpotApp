import HealthKit
import CaBFoundation

public protocol HealthDataTracking: AnyObject {
    func observerHeartRateSamples()
}

public final class HealthDataTrackingImpl: HealthDataTracking {

    // MARK: - Internal Properties

    let healthStore: HKHealthStore
    var observerQuery: HKObserverQuery!

    private let localNotificationsAssistant: LocalNotificationAssistant

    // MARK: - Init

    init(localNotificationsAssistant: LocalNotificationAssistant) {
        healthStore = HKHealthStore()

        self.localNotificationsAssistant = localNotificationsAssistant
    }

    // MARK: - Internal Methods

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
                } else if let error = error {
                    logWarning(message: "HealthKit authorization failed with error: <\(error.localizedDescription)>")
                }
            }
        } else {
            logInfo(message: "HealthKit not avaiable")
        }

    }

    func observerHeartRateSamples() {
        guard let heartRateSampleType = HKObjectType.quantityType(forIdentifier: .heartRate) else {
            return
        }

        if let observerQuery = observerQuery {
            healthStore.stop(observerQuery)
        }

        observerQuery = HKObserverQuery(sampleType: heartRateSampleType, predicate: nil) { [unowned self] (_, _, error) in
            if let error = error {
                logWarning(message: "Error was obtained: <\(error.localizedDescription)>")
                return
            }

            self.fetchLatestHeartRateSample { (sample) in
                guard let sample = sample else {
                    return
                }

                DispatchQueue.main.async {
                    let heartRateUnit = HKUnit.count().unitDivided(by: HKUnit.minute())
                    let heartRate = sample.quantity.doubleValue(for: heartRateUnit)
                    logInfo(message: "Heart Rate Sample: \(heartRate)")

                    localNotificationsAssistant.push(notificationContent: .init(title: "Current heart rate",
                                                                                body: "Heart Reate = \(heartRate)",
                                                                                category: "alarm",
                                                                                userInfo: ["customData": "fizzbuzz"]))
                }
            }
        }

        healthStore.execute(observerQuery)
        healthStore.enableBackgroundDelivery(for: heartRateSampleType, frequency: .immediate) { (success, error) in
            if success {
                NSLog("$@", "Success enable backgorund delivery <\(success)>")
            }
            if let error = error {
                NSLog("%@", "Error was obtained: <\(error.localizedDescription)>")
            }
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

}
