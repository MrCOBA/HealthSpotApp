import Foundation

extension UserDefaults.Key {

    enum HealthActivityStatistics {

        static var heartRate: String {
            return "HealthActivityStatisticsHeartRateKey"
        }

        static var stepsCount: String {
            return "HealthActivityStatisticsStepsCountKey"
        }

        static var burnedCallories: String {
            return "HealthActivityStatisticsBurnedCalloriesKey"
        }

        static var heartRateNorm: String {
            return "HealthActivityStatisticsHeartRateNormKey"
        }

        static var stepsGoal: String {
            return "HealthActivityStatisticsStepsGoalKey"
        }

        static var calloriesGoal: String {
            return "HealthActivityStatisticsCalloriesGoalKey"
        }

        static var isTrackingEnabled: String {
            return "HealthActivityStatisticsIsTrackingEnabledKey"
        }
        
    }

}
