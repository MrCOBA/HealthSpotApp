import CaBFoundation

final class HealthActivityAchievementsNotificationsFactory {

    enum Achievement: String {
        case startGoal
        case halfGoal
        case fullGoal
    }

    func makeStepsNotification(for achievement: Achievement) -> LocalNotificationAssistantImpl.Content {
        let title: String
        let body: String

        switch achievement {
        case .startGoal:
            title = "Good luck and win!"
            body = "You will beat all records today."

        case .halfGoal:
            title = "You have to try harder!"
            body = "Equator passed, more to come."

        case .fullGoal:
            title = "Congratulations! You are the best today!"
            body = "The day's goals are fulfilled, you can rest!"
        }
        return .init(identifier: "stepsAchievement_\(achievement.rawValue)",
                     title: title,
                     body: body,
                     category: "alert",
                     userInfo: [:])
    }

    func makeCalloriesNotification(for achievement: Achievement) -> LocalNotificationAssistantImpl.Content {
        let title: String
        let body: String

        switch achievement {
        case .startGoal:
            title = "It won't be easy, but you can do it!"
            body = "We're just getting started, push on."

        case .halfGoal:
            title = "A few more steps and you're there!"
            body = "Half is more than nothing."

        case .fullGoal:
            title = "Omg, you're great today!"
            body = "Can you do it again tomorrow?"
        }
        return .init(identifier: "calloriesAchievement_\(achievement.rawValue)",
                     title: title,
                     body: body,
                     category: "alert",
                     userInfo: [:])
    }
    
}
