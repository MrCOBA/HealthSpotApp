import UIKit

extension UINavigationController {

    public func embedIn(_ viewController: UIViewController, animated: Bool) {
        setViewControllers([viewController], animated: animated)
    }

}
