import UIKit

public final class AdaptivePresentationDelegateProxyImpl: NSObject, AdaptivePresentationDelegateProxy {

    // MARK: - Public Properties

    public weak var adaptivePresentationDelegate: AdaptivePresentationControllerDelegate?
    public weak var dismissHandlerDelegate: PresentationControllerDismissHandlerDelegate?

}

// MARK: - UIAdaptivePresentationControllerDelegate

extension AdaptivePresentationDelegateProxyImpl: UIAdaptivePresentationControllerDelegate {

    // MARK: - AdaptivePresentationControllerDelegate's invocations

    public func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return adaptivePresentationDelegate?.adaptivePresentationStyle(for: controller) ?? controller.presentationStyle
    }

    public func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        if let style = adaptivePresentationDelegate?.adaptivePresentationStyle(for: controller, traitCollection: traitCollection) {
            return style
        }
        else {
            return adaptivePresentationStyle(for: controller)
        }
    }

    public func presentationController(_ controller: UIPresentationController,
                                       viewControllerForAdaptivePresentationStyle style: UIModalPresentationStyle) -> UIViewController? {
        return adaptivePresentationDelegate?.presentationController(controller, viewControllerForAdaptivePresentationStyle: style) ?? nil
    }

    public func presentationController(_ presentationController: UIPresentationController,
                                       willPresentWithAdaptiveStyle style: UIModalPresentationStyle,
                                       transitionCoordinator: UIViewControllerTransitionCoordinator?) {
        adaptivePresentationDelegate?.presentationController(presentationController,
                                                             willPresentWithAdaptiveStyle: style,
                                                             transitionCoordinator: transitionCoordinator)
    }

    // MARK: - PresentationControllerDismissHandlerDelegate's invocations

    @available(iOS 13.0, *)
    public func presentationControllerShouldDismiss(_ presentationController: UIPresentationController) -> Bool {
        return dismissHandlerDelegate?.presentationControllerShouldDismiss(presentationController) ?? true
    }

    @available(iOS 13.0, *)
    public func presentationControllerWillDismiss(_ presentationController: UIPresentationController) {
        dismissHandlerDelegate?.presentationControllerWillDismiss(presentationController)
    }

    @available(iOS 13.0, *)
    public func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        dismissHandlerDelegate?.presentationControllerDidDismiss(presentationController)
    }

    @available(iOS 13.0, *)
    public func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
        dismissHandlerDelegate?.presentationControllerDidAttemptToDismiss(presentationController)
    }

}
