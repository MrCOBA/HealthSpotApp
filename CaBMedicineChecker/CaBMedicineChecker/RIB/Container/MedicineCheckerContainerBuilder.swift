import CaBRiblets
import CaBUIKit

// MARK: - Builder

public final class MedicineCheckerContainerBuilder: Builder {

    // MARK: - Private Properties

    private weak var listener: MedicineCheckerContainerListener?

    // MARK: -  Init

    public init(listener: MedicineCheckerContainerListener?) {
        self.listener = listener
    }

    // MARK: - Public Methods

    public func build() -> ViewableRouter {
        let view = CaBNavigationController()
        view.isNavigationBarHidden = true

        let interactor = MedicineCheckerContainerInteractor(listener: listener)

        let router = MedicineCheckerContainerRouterImpl(view: view, interactor: interactor)
        interactor.router = router

        return router
    }

}
