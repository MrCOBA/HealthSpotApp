import CaBSDK

extension UserDefaults.Key {

    enum Authorization {

        static var id: String {
            return "AuthorizationTemporaryIdKey"
        }

        static var email: String {
            return "AuthorizationTemporaryEmailKey"
        }

        static var password: String {
            return "AuthorizationTemporaryPasswordKey"
        }

        static var repeatedPassword: String {
            return "AuthorizationTemporaryRepeatedPasswordKey"
        }

    }

}
