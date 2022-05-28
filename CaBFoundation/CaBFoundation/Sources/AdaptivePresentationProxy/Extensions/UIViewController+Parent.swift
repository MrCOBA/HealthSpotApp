import UIKit

extension UIViewController {

    // MARK: - Public Methods

    public func getParentPresentationController() -> UIPresentationController? {
        var currentParent: UIViewController = self
        while let parent = currentParent.parent {
            currentParent = parent
        }

        return currentParent.presentationController
    }

    // MARK: - Internal Methods

    func assertGetPresentationControllerFailure(file: StaticString = #file, line: UInt = #line) {
        let message = """
                    Expecting `presentationController` to be not nil for <\(self)>.
                    Check out that current method's getting called after `modalPresentationStyle` is set for `viewController`.
                    If you are setting `transitioningDelegate` to the `viewController` and want to configure `AdaptivePresentationDelegateProxy`,
                    make sure your `transitioningDelegate` implements method `func presentationController(forPresented:presenting:source:)`
                    which returns not nil `UIPresentationController`-instance.
                    """
        logError(message: message)
    }

}
