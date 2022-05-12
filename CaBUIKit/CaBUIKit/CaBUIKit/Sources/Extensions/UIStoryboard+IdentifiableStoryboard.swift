import UIKit

public protocol IdentifiableStoryboard {

    static var identifier: String { get }
    static var bundle: Bundle { get }
    static var storyboard: UIStoryboard { get }

    static func instantiateInitialViewController() -> UIViewController?
    static func instantiateViewController<T: UIViewController>(withIdentifier identifier: String) -> T

}

extension IdentifiableStoryboard {

    public static var storyboard: UIStoryboard {
        return UIStoryboard(name: self.identifier, bundle: bundle)
    }

    public static func instantiateInitialViewController() -> UIViewController? {
        return self.storyboard.instantiateInitialViewController()
    }

    public static func instantiateViewController<T: UIViewController>(withIdentifier identifier: String) -> T {
        return self.storyboard.instantiateViewController(withIdentifier: identifier)
    }

}

// MARK: - Storyboard Helpers

extension UIStoryboard {

    public func instantiateViewController<T: UIViewController>(withIdentifier identifier: String) -> T {
        guard let controller = instantiateViewController(withIdentifier: identifier) as? T else {
            fatalError("Can't instantiate controller with identifier \(identifier)")
        }

        return controller
    }

}
