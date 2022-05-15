import CaBRiblets

final class MedicineItemPeriodBuilder: Builder {

    // MARK: - Internal Properties

    weak var listener: MedicineItemPeriodListener?

    // MARK: - Init

    init(listener: MedicineItemPeriodListener?) {
        self.listener = listener
    }

    // MARK: - Internal Methods

    func build() -> ViewableRouter {
        let view = MedicineItemPeriodView.makeView()

        let storage = MedicineItemPeriodTemporaryStorageImpl()

        let presenter = MedicineItemPeriodPresenterImpl(view: view, storage: storage)
        let interactor = MedicineItemPeriodInteractorImpl(storage: storage, presenter: presenter, listener: listener)

        presenter.interactor = interactor

        let router = MedicineItemPeriodRouter(view: view, interactor: interactor)

        return router
    }

}
