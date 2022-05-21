import CaBRiblets

final class MedicineListBuilder: Builder {

    // MARK: - Private Properties

    private let factory: MedicineCheckerRootServices

    // MARK: - Init

    init(factory: MedicineCheckerRootServices) {
        self.factory = factory
    }

    // MARK: - Internal Methods

    func build() -> ViewableRouter {
        let view = MedicineListView.makeView()

        let presenter = MedicineListPresenterImpl(view: view)
        let interactor = MedicineListInteractorImpl(coreDataAssistant: factory.coreDataAssistant)

        presenter.interactor = interactor

        let router = MedicineListRouterImpl(rootServices: factory, view: view, interactor: interactor)

        return router
    }

}
