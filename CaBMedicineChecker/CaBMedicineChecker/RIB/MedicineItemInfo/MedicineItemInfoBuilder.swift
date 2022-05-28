import CaBRiblets

final class MedicineItemInfoBuilder: Builder {

    // MARK: - Private Properties

    private weak var listener: MedicineItemInfoListener?
    private let factory: MedicineCheckerRootServices

    // MARK: - Init

    init(factory: MedicineCheckerRootServices, listener: MedicineItemInfoListener?) {
        self.listener = listener
        self.factory = factory
    }

    // MARK: - Internal Methods

    func build(with id: String) -> ViewableRouter {
        let view = MedicineItemInfoView.makeView()

        let presenter = MedicineItemInfoPresenterImpl(view: view)
        view.eventsHandler = presenter
        
        let interactor = MedicineItemInfoInteractorImpl(firebaseFirestoreMedicineCheckerController: factory.firebaseFirestoreMedicineCheckerController,
                                                        itemPeriodTemporaryStorage: factory.medicineItemPeriodStorage,
                                                        coreDataAssistant: factory.coreDataAssistant,
                                                        presenter: presenter,
                                                        entityId: id,
                                                        listener: listener)
        presenter.interactor = interactor

        let router = MedicineItemInfoRouterImpl(rootServices: factory, view: view, interactor: interactor)
        interactor.router = router

        return router
    }

}
