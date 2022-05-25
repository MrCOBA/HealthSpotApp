import Foundation

extension UserDefaults.Key {

    enum HealthActivityStatistics {

        static var heartRate: String {
            return "HealthActivityStatisticsHeartRateKey"
        }

        static var stepsCount: String {
            return "HealthActivityStatisticsStepsCountKey"
        }

        static var burntCallories: String {
            return "HealthActivityStatisticsBurntCalloriesKey"
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
        
    }

}
