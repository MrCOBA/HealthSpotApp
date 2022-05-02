
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

    // MARK: Authorization

    public enum Authorization {

        public static func signIn(result: Notification.Name.Result) -> Notification.Name {
            switch result {
                case .success:
                    return .init(rawValue: "SignIn_SuccessfullyCompleted")

                case let .failure(error):
                return .init(rawValue: "SignIn_FailedWithError_<\(error.rawValue)>")
            }
        }

        public static func signUp(result: Notification.Name.Result) -> Notification.Name {
            switch result {
                case .success:
                    return .init(rawValue: "SignUp_SuccessfullyCompleted")

                case let .failure(error):
                return .init(rawValue: "SignUp_FailedWithError_<\(error.rawValue)>")
            }
        }

    }

}
