
extension UserDefaults {

    public enum Key {

        enum Foundation {

            static var isNotificationPermissionsRequested: String {
                return "HealthSpotNotificationRequestKey"
            }

            static var isNotificationEnabled: String {
                return "HealthSpotNotificationAvailablityKey"
            }

            static var isOfflineModeOn: String {
                return "HealthSpotOfflineModeKey"
            }

        }

        enum Cache {

            static var cachedBuffer: String {
                return "HealthSpotCachedBufferKey"
            }

        }
        
    }
    
}
