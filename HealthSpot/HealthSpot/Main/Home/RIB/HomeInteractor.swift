import CaBRiblets
import CaBFoundation

protocol HomeInteractor: Interactor {

}

final class HomeInteractorImpl: BaseInteractor, HomeInteractor {

    typealias MedicineItemCompositeWrapper = CompositeWrapper<MedicineItemEntityWrapper, MedicineItemPeriodEntityWrapper>

    weak var router: HomeRouter?
    var presenter: HomePresenter?

    private let rootServices: RootServices

    init(rootServices: RootServices,
         presenter: HomePresenter) {
        self.rootServices = rootServices
        self.presenter = presenter
    }

    override func start() {
        super.start()
    }

    override func stop() {
        super.stop()
    }

    private func updateView() {
        presenter?.updateView()
    }

    private func checkIfRouterSet() {
        if router == nil {
            logError(message: "Router expected to be set")
        }
    }

}
