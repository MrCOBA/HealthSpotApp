import CaBRiblets
import CaBFoundation

protocol HomeInteractor: Interactor {

    func startStatisticsTracking()
    func stopStatisticsTracking()

}

final class HomeInteractorImpl: BaseInteractor, HomeInteractor {

    typealias MedicineItemCompositeWrapper = CompositeWrapper<MedicineItemEntityWrapper, MedicineItemPeriodEntityWrapper>

    weak var router: HomeRouter?
    var presenter: HomePresenter?

    private let statisticsStorage: HealthActivityStatisticsStorage

    init(statisticsStorage: HealthActivityStatisticsStorage,
         presenter: HomePresenter) {
        self.statisticsStorage = statisticsStorage
        self.presenter = presenter
    }

    override func start() {
        super.start()

        statisticsStorage.add(observer: self)
    }

    override func stop() {
        super.stop()
    }

    func startStatisticsTracking() {
        checkIfRouterSet()

        router?.attachStatisticsRouter()
    }

    func stopStatisticsTracking() {
        
    }

    private func updateView() {
        presenter?.updateView(from: statisticsStorage)
    }

    private func checkIfRouterSet() {
        if router == nil {
            logError(message: "Router expected to be set")
        }
    }

}

extension HomeInteractorImpl: HealthActivityStatisticsStorageObserver {

    func storage(_ storage: HealthActivityStatisticsStorage,
                 didUpdateHeartRateTo newValue: Double) {
        presenter?.updateView(from: statisticsStorage)
    }

    func storage(_ storage: HealthActivityStatisticsStorage,
                 didUpdateStepsCountTo newValue: Double) {
        presenter?.updateView(from: statisticsStorage)
    }

    func storage(_ storage: HealthActivityStatisticsStorage,
                 didUpdateBurntCalloriesTo newValue: Double) {
        presenter?.updateView(from: statisticsStorage)
    }

    func storage(_ storage: HealthActivityStatisticsStorage,
                 didUpdateHeartRateNormTo newValue: Double) {
        presenter?.updateView(from: statisticsStorage)
    }

    func storage(_ storage: HealthActivityStatisticsStorage,
                 didUpdateStepsGoalTo newValue: Double) {
        presenter?.updateView(from: statisticsStorage)
    }

    func storage(_ storage: HealthActivityStatisticsStorage,
                 didUpdateCalloriesGoalTo newValue: Double) {
        presenter?.updateView(from: statisticsStorage)
    }

}
