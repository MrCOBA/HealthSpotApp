import UIKit

extension UITabBarController {

    public func embedIn(_ viewController: UIViewController, animated: Bool) {
        setViewControllers([viewController], animated: animated)
    }

}
