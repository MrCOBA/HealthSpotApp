
extension Notification.Name {

    // MARK: Authorization

    public enum Authorization {

        public static var firebaseSignInSuccess: Notification.Name {
            return .init(rawValue: "SignIn_FailedWithError_<FirebaseError>")
        }

        public static var firebaseSignInError: Notification.Name {
            return .init(rawValue: "SignIn_FailedWithError_<FirebaseError>")
        }

        public static var firebaseSignUpError: Notification.Name {
            return .init(rawValue: "SignUp_FailedWithError_<FirebaseError>")
        }

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
