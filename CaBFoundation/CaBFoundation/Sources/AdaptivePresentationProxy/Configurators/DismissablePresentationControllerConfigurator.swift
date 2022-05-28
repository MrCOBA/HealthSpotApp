import UIKit

// MARK: - DismissablePresentationControllerConfigurator

public protocol DismissablePresentationControllerConfigurator: AnyObject {

    var adaptivePresentationProxy: AdaptivePresentationDelegateProxy? { get set }

    func configurePresentationController(_ presentationController: UIPresentationController,
                                         with dismissDelegate: PresentationControllerDismissHandlerDelegate)

    func configurePresentationController(for presentedController: UIViewController,
                                         with dismissDelegate: PresentationControllerDismissHandlerDelegate)

}

// MARK: - DismissablePresentationControllerConfigurator Extensions

public extension DismissablePresentationControllerConfigurator {

    func configurePresentationController(_ presentationController: UIPresentationController,
                                         with dismissDelegate: PresentationControllerDismissHandlerDelegate) {
        adaptivePresentationProxy = presentationController.setDismissHandlerDelegate(dismissDelegate,
                                                                                     using: adaptivePresentationProxy)
    }

    func configurePresentationController(for presentedController: UIViewController, with dismissDelegate: PresentationControllerDismissHandlerDelegate) {
        guard let presentationViewController = presentedController.presentationController else {
            presentedController.assertGetPresentationControllerFailure()
            return
        }

        configurePresentationController(presentationViewController, with: dismissDelegate)
    }

}

public extension DismissablePresentationControllerConfigurator where Self: UIViewController {

    func configurePresentationController(with dismissDelegate: PresentationControllerDismissHandlerDelegate) {
        configurePresentationController(for: self, with: dismissDelegate)
    }

}

public extension DismissablePresentationControllerConfigurator where Self: UIViewController & PresentationControllerDismissHandlerDelegate  {

    func configurePresentationController() {
        configurePresentationController(with: self)
    }

}

// MARK: - Protocol DismissableAdaptivePresentationViewController

public protocol DismissableAdaptivePresentationViewController: UIViewController, DismissablePresentationControllerConfigurator, PresentationControllerDismissHandlerDelegate {
    func configurePresentationController()
}

// MARK: - DismissableAdaptivePresentationViewController Extension

public extension DismissableAdaptivePresentationViewController {

    func configurePresentationController() {
        guard let presentationController = getParentPresentationController() else {
            assertGetPresentationControllerFailure()
            return
        }

        configurePresentationController(presentationController, with: self)
    }

}
