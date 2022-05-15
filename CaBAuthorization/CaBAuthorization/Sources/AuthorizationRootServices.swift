
public protocol AuthorizationRootServices: AnyObject {

    var authorizationManager: AuthorizationManager { get }
    var credentialsStorage: AuthorithationCredentialsTemporaryStorage { get }

}
