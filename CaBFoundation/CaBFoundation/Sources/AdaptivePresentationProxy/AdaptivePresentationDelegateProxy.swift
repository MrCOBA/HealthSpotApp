import UIKit

// MARK: - Protocol AdaptivePresentationControllerDelegate

public protocol AdaptivePresentationControllerDelegate: AnyObject {

    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle

    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle

    func presentationController(_ controller: UIPresentationController,
                                viewControllerForAdaptivePresentationStyle style: UIModalPresentationStyle) -> UIViewController?

    func presentationController(_ presentationController: UIPresentationController,
                                willPresentWithAdaptiveStyle style: UIModalPresentationStyle,
                                transitionCoordinator: UIViewControllerTransitionCoordinator?)

}

public extension AdaptivePresentationControllerDelegate {

    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return controller.presentationStyle
    }

    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return adaptivePresentationStyle(for: controller)
    }

    func presentationController(_ controller: UIPresentationController,
                                viewControllerForAdaptivePresentationStyle style: UIModalPresentationStyle) -> UIViewController? {
        return nil
    }

    func presentationController(_ presentationController: UIPresentationController,
                                willPresentWithAdaptiveStyle style: UIModalPresentationStyle,
                                transitionCoordinator: UIViewControllerTransitionCoordinator?) {
        /* Do Nothing */
    }
}

// MARK: - Protocol PresentationControllerDismissHandlerDelegate

public protocol PresentationControllerDismissHandlerDelegate: AnyObject {

    @available(iOS 13.0, *)
    func presentationControllerShouldDismiss(_ presentationController: UIPresentationController) -> Bool

    @available(iOS 13.0, *)
    func presentationControllerWillDismiss(_ presentationController: UIPresentationController)

    @available(iOS 13.0, *)
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController)

    @available(iOS 13.0, *)
    func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController)

}

public extension PresentationControllerDismissHandlerDelegate {

    func presentationControllerShouldDismiss(_ presentationController: UIPresentationController) -> Bool {
        return true
    }

    func presentationControllerWillDismiss(_ presentationController: UIPresentationController) {
        /* Do Nothing */
    }

    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        /* Do Nothing */
    }

    func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
        /* Do Nothing */
    }

}

// MARK: - Protocol AdaptivePresentationDelegateProxy

public protocol AdaptivePresentationDelegateProxy: UIAdaptivePresentationControllerDelegate {
    var adaptivePresentationDelegate: AdaptivePresentationControllerDelegate? { get set }
    var dismissHandlerDelegate: PresentationControllerDismissHandlerDelegate? { get set }
}

