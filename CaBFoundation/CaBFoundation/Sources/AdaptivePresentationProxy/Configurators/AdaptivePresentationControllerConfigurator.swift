import UIKit

// MARK: - AdaptivePresentationControllerConfigurator

public protocol AdaptivePresentationControllerConfigurator: AnyObject {

    var adaptivePresentationProxy: AdaptivePresentationDelegateProxy? { get set }

    func configurePresentationController(_ presentationController: UIPresentationController,
                                         with presentationDelegate: AdaptivePresentationControllerDelegate)

    func configurePresentationController(for presentedController: UIViewController,
                                         with presentationDelegate: AdaptivePresentationControllerDelegate)

}

// MARK: - AdaptivePresentationControllerConfigurator extensions

public extension AdaptivePresentationControllerConfigurator {

    func configurePresentationController(_ presentationController: UIPresentationController,
                                         with presentationDelegate: AdaptivePresentationControllerDelegate) {
        adaptivePresentationProxy = presentationController.setPresentationDelegate(presentationDelegate,
                                                                                   using: adaptivePresentationProxy)
    }

    func configurePresentationController(for presentedController: UIViewController,
                                         with presentationDelegate: AdaptivePresentationControllerDelegate) {
        guard let presentationViewController = presentedController.presentationController else {
            presentedController.assertGetPresentationControllerFailure()
            return
        }

        configurePresentationController(presentationViewController, with: presentationDelegate)
    }

}

public extension AdaptivePresentationControllerConfigurator where Self: AdaptivePresentationControllerDelegate {

    func configurePresentationController(_ presentationController: UIPresentationController) {
        configurePresentationController(presentationController, with: self)
    }

    func configurePresentationController(for presentedController: UIViewController) {
        configurePresentationController(for: presentedController, with: self)
    }

}
