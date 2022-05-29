
extension UserDefaults {

    public enum Key {

        enum Foundation {

            static var isNotificationPermissionsRequested: String {
                return "HealthSpotNotificationRequestKey"
            }

        }

        enum Cache {

            static var cachedBuffer: String {
                return "HealthSpotCachedBufferKey"
            }

        }
        
    }
    
}
