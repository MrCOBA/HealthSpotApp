
extension Notification.Name {

    // MARK: Authorization

    enum Authorization {

        static func signIn(result: Notification.Name.Result) -> Notification.Name {
            switch result {
                case .success:
                    return .init(rawValue: "SignIn_SuccessfullyCompleted")

                case let .failure(error):
                return .init(rawValue: "SignIn_FailedWithError_<\(error.rawValue)>")
            }
        }

        static func signUp(result: Notification.Name.Result) -> Notification.Name {
            switch result {
                case .success:
                    return .init(rawValue: "SignUp_SuccessfullyCompleted")

                case let .failure(error):
                return .init(rawValue: "SignUp_FailedWithError_<\(error.rawValue)>")
            }
        }

    }

}
