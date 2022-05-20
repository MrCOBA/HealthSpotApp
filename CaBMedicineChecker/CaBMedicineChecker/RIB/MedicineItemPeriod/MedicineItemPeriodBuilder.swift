import CaBRiblets

final class MedicineItemPeriodBuilder: Builder {

    // MARK: - Private Properties

    private weak var listener: MedicineItemPeriodListener?
    private let factory: MedicineCheckerRootServices

    // MARK: - Init

    init(factory: MedicineCheckerRootServices, listener: MedicineItemPeriodListener?) {
        self.factory = factory
        self.listener = listener
    }

    // MARK: - Internal Methods

    func build() -> ViewableRouter {
        let view = MedicineItemPeriodView.makeView()

        let presenter = MedicineItemPeriodPresenterImpl(view: view, storage: factory.medicineItemPeriodStorage)
        let interactor = MedicineItemPeriodInteractorImpl(storage: factory.medicineItemPeriodStorage,
                                                          presenter: presenter,
                                                          listener: listener)

        presenter.interactor = interactor

        let router = MedicineItemPeriodRouter(view: view, interactor: interactor)

        return router
    }

}
