
extension Notification.Name {

    public struct Error: RawRepresentable, Equatable, Hashable, Comparable {

        // MARK: - Public Types

        public typealias RawValue = String

        // MARK: - Public Properties

        public var rawValue: String

        // MARK: Protocol Hashable

        public var hashValue: Int {
            return rawValue.hashValue
        }

        // MARK: Cases

        public static let incorrectFormat = Error(rawValue: "incorrectFormat")
        public static let noInternetConnection = Error(rawValue: "noInternetConnection")

        public init(rawValue: String) {
            self.rawValue = rawValue
        }

        // MARK: Protocol Comparable

        public static func <(lhs: Error, rhs: Error) -> Bool {
            return lhs.rawValue < rhs.rawValue
        }

    }

    public enum Result {
        case success
        case failure(error: Error)
    }

}
