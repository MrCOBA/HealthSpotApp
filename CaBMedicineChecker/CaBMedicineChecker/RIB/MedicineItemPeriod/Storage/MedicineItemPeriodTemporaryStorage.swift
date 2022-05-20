import CaBSDK

// MARK: - Protocol

public protocol MedicineItemPeriodTemporaryStorage: AnyObject {

    var startDate: Date { get set }
    var endDate: Date? { get set }
    var frequency: String? { get set }
    var notificationHint: String { get set }

    func clear()

}

// MARK: - Implementation

public final class MedicineItemPeriodTemporaryStorageImpl: MedicineItemPeriodTemporaryStorage {

    // MARK: - Public Properties

    @UserDefaultsStored
    public var startDate: Date

    @UserDefaultsStored
    public var endDate: Date?

    @UserDefaultsStored
    public var frequency: String?

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
        self._frequency = .init(underlyingDefaults: userDefaults,
                                key: UserDefaults.Key.MedicineChecker.frequency,
                                defaultValue: nil)
        self._notificationHint = .init(underlyingDefaults: userDefaults,
                                       key: UserDefaults.Key.MedicineChecker.notificationHint,
                                       defaultValue: "")
    }

    // MARK: - Public Methods

    public func clear() {
        startDate = Date()
        endDate = nil
        frequency = nil
        notificationHint = ""
    }

}
