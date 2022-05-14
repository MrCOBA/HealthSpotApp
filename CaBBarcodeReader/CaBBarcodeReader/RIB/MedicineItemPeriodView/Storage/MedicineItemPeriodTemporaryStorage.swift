import CaBSDK

// MARK: - Protocol

public protocol MedicineItemPeriodTemporaryStorage: AnyObject {

    var startDate: Date { get set }
    var endDate: Date? { get set }
    var repeatType: String? { get set }
    var notificationHint: String { get set }

}

// MARK: - Implementation

final class MedicineItemPeriodTemporaryStorageImpl: MedicineItemPeriodTemporaryStorage {

    // MARK: - Public Properties

    @UserDefaultsStored
    public var startDate: Date

    @UserDefaultsStored
    public var endDate: Date?

    @UserDefaultsStored
    public var repeatType: String?

    @UserDefaultsStored
    public var notificationHint: String

    // MARK: - Init

    public init(userDefaults: UserDefaults = .standard) {
        self._startDate = .init(underlyingDefaults: userDefaults,
                                key: UserDefaults.Key.MedicineChecker.startDate,
                                defaultValue: Date())
        self._endDate = .init(underlyingDefaults: userDefaults,
                              key: UserDefaults.Key.MedicineChecker.endDate,
                              defaultValue: nil)
        self._repeatType = .init(underlyingDefaults: userDefaults,
                                 key: UserDefaults.Key.MedicineChecker.repeatType,
                                 defaultValue: nil)
        self._notificationHint = .init(underlyingDefaults: userDefaults,
                                       key: UserDefaults.Key.MedicineChecker.notificationHint,
                                       defaultValue: "")
    }

}
