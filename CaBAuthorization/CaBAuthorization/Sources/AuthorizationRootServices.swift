import CaBSDK

public protocol AuthorizationRootServices: AnyObject {

    var coreDataAssistant: CoreDataAssistant { get }
    var authorizationManager: AuthorizationManager { get }
    var credentialsStorage: AuthorithationCredentialsTemporaryStorage { get }

}
