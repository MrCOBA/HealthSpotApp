import UIKit

open class BaseContainerViewController: UIViewController {

    private var currentChild: UIViewController?

    open override func addChild(_ childController: UIViewController) {
        if currentChild != nil {
            removeChild()
        }

        super.addChild(childController)

        view.addSubview(childController.view)
        childController.view.frame = view.bounds
        childController.view.autoresizingMask = [.flexibleHeight, .flexibleWidth]

        childController.didMove(toParent: self)
        currentChild = childController
    }

    private func removeChild() {
        currentChild?.willMove(toParent: nil)
        currentChild?.view.removeFromSuperview()
        currentChild?.removeFromParent()
    }

}
