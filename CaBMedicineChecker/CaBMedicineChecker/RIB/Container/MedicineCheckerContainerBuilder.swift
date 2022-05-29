import CaBRiblets
import CaBUIKit

// MARK: - Builder

public final class MedicineCheckerContainerBuilder: Builder {

    // MARK: - Private Properties

    private let factory: MedicineCheckerRootServices

    // MARK: -  Init

    public init(factory: MedicineCheckerRootServices) {
        self.factory = factory
    }

    // MARK: - Public Methods

    public func build() -> ViewableRouter {
        let view = CaBNavigationController()
        view.isNavigationBarHidden = false
        view.colorScheme = factory.colorScheme

        let interactor = MedicineCheckerContainerInteractorImpl()

        let router = MedicineCheckerContainerRouterImpl(rootServices: factory, view: view, interactor: interactor)
        interactor.router = router

        return router
    }

}
