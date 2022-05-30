import CaBFoundation
import Foundation

// MARK: - Protocol

public protocol HealthActivityAchievementsStorage: AnyObject {

    var currentDate: Date { get set }

    var isStartStepsAchievementReceived: Bool { get set }
    var isHalfStepsAchievementReceived: Bool { get set }
    var isFullStepsAchievementReceived: Bool { get set }

    var isStartCalloriesAchievementReceived: Bool { get set }
    var isHalfCalloriesAchievementReceived: Bool { get set }
    var isFullCalloriesAchievementReceived: Bool { get set }

    func resetStorage()

}

// MARK: - Implementation

final class HealthActivityAchievementsStorageImpl: HealthActivityAchievementsStorage {

    // MARK: - Private Types

    private typealias Key = UserDefaults.Key.HealthActivityAchievements

    // MARK: - Internal Properties

    @UserDefaultsStored
    var currentDate: Date

    @UserDefaultsStored
    var isStartStepsAchievementReceived: Bool

    @UserDefaultsStored
    var isHalfStepsAchievementReceived: Bool

    @UserDefaultsStored
    var isFullStepsAchievementReceived: Bool

    @UserDefaultsStored
    var isStartCalloriesAchievementReceived: Bool

    @UserDefaultsStored
    var isHalfCalloriesAchievementReceived: Bool

    @UserDefaultsStored
    var isFullCalloriesAchievementReceived: Bool

    // MARK: - Init

    init(userDefults: UserDefaults = .standard) {
        _currentDate = UserDefaultsStored(underlyingDefaults: userDefults, key: Key.currentDate, defaultValue: Date())
        _isStartStepsAchievementReceived = UserDefaultsStored(underlyingDefaults: userDefults, key: Key.isStartStepsAchievementReceived, defaultValue: false)
        _isHalfStepsAchievementReceived = UserDefaultsStored(underlyingDefaults: userDefults, key: Key.isHalfStepsAchievementReceived, defaultValue: false)
        _isFullStepsAchievementReceived = UserDefaultsStored(underlyingDefaults: userDefults, key: Key.isFullStepsAchievementReceived, defaultValue: false)
        _isStartCalloriesAchievementReceived = UserDefaultsStored(underlyingDefaults: userDefults, key: Key.isStartCalloriesAchievementReceived, defaultValue: false)
        _isHalfCalloriesAchievementReceived = UserDefaultsStored(underlyingDefaults: userDefults, key: Key.isHalfCalloriesAchievementReceived, defaultValue: false)
        _isFullCalloriesAchievementReceived = UserDefaultsStored(underlyingDefaults: userDefults, key: Key.isFullCalloriesAchievementReceived, defaultValue: false)
    }

    func resetStorage() {
        currentDate = Date()

        isStartStepsAchievementReceived = false
        isHalfStepsAchievementReceived = false
        isFullStepsAchievementReceived = false

        isStartCalloriesAchievementReceived = false
        isHalfCalloriesAchievementReceived = false
        isFullCalloriesAchievementReceived = false
    }

}
