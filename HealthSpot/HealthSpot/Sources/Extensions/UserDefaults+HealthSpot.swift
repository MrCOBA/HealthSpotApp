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

    enum HealthActivityAchievements {

        static var currentDate: String {
            return "HealthActivityAchievementsCurrentDateKey"
        }

        static var isStartStepsAchievementReceived: String {
            return "HealthActivityStatisticsStartStepsKey"
        }

        static var isHalfStepsAchievementReceived: String {
            return "HealthActivityAchievementsHalfStepsKey"
        }

        static var isFullStepsAchievementReceived: String {
            return "HealthActivityAchievementsFinalStepsKey"
        }

        static var isStartCalloriesAchievementReceived: String {
            return "HealthActivityAchievementsStartCalloriesKey"
        }

        static var isHalfCalloriesAchievementReceived: String {
            return "HealthActivityAchievementsHalfCalloriesKey"
        }

        static var isFullCalloriesAchievementReceived: String {
            return "HealthActivityAchievementsFinalCalloriesKey"
        }

    }

}
