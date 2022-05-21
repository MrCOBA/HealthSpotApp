import CaBRiblets

final class MedicineItemInfoBuilder: Builder {

    // MARK: - Private Properties

    private let factory: MedicineCheckerRootServices

    // MARK: - Init

    init(factory: MedicineCheckerRootServices) {
        self.factory = factory
    }

    // MARK: - Internal Methods

    func build(with id: Int16) -> ViewableRouter {
        let view = MedicineItemInfoView.makeView()

        let presenter = MedicineItemInfoPresenterImpl(view: view)
        let interactor = MedicineItemInfoInteractorImpl(coreDataAssistant: factory.coreDataAssistant, entityId: id)

        presenter.interactor = interactor

        let router = MedicineItemInfoRouterImpl(rootServices: factory, view: view, interactor: interactor)

        return router
    }

}
