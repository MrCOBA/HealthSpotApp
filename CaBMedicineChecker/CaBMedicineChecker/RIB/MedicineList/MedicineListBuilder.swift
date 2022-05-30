import CaBRiblets

final class MedicineListBuilder: Builder {

    // MARK: - Private Properties

    private let factory: MedicineCheckerRootServices
    private weak var listener: MedicineListListener?

    // MARK: - Init

    init(factory: MedicineCheckerRootServices, listener: MedicineListListener?) {
        self.factory = factory
        self.listener = listener
    }

    // MARK: - Internal Methods

    func build() -> ViewableRouter {
        let view = MedicineListView.makeView()

        let presenter = MedicineListPresenterImpl(view: view, cachedStorage: factory.cachedStorage, rootSettingsStorage: factory.rootSettingsStorage)
        view.eventsHandler = presenter
        
        let interactor = MedicineListInteractorImpl(coreDataAssistant: factory.coreDataAssistant,
                                                    presenter: presenter,
                                                    firebaseFirestoreMedicineCheckerController: factory.firebaseFirestoreMedicineCheckerController,
                                                    rootSettingsStorage: factory.rootSettingsStorage,
                                                    listener: listener)

        presenter.interactor = interactor

        let router = MedicineListRouterImpl(rootServices: factory, view: view, interactor: interactor)
        interactor.router = router

        return router
    }

}
