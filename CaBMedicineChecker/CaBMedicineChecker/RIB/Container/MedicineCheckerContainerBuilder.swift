import CaBRiblets
import CaBUIKit

// MARK: - Builder

public final class MedicineCheckerContainerBuilder: Builder {

    // MARK: - Private Properties

    private weak var listener: MedicineCheckerContainerListener?
    private let factory: MedicineCheckerRootServices

    // MARK: -  Init

    public init(factory: MedicineCheckerRootServices, listener: MedicineCheckerContainerListener?) {
        self.factory = factory
        self.listener = listener
    }

    // MARK: - Public Methods

    public func build() -> ViewableRouter {
        let view = CaBNavigationController()
        view.isNavigationBarHidden = false
        view.colorScheme = factory.colorScheme

        let interactor = MedicineCheckerContainerInteractor(listener: listener)

        let router = MedicineCheckerContainerRouterImpl(rootServices: factory, view: view, interactor: interactor)
        interactor.router = router

        return router
    }

}
