import CaBRiblets
import CaBFoundation

protocol HomePresenter: AnyObject {

    func updateView(from storage: HealthActivityStatisticsStorage)

}

final class HomePresenterImpl: HomePresenter {

    weak var view: HomeView?
    weak var interactor: HomeInteractor?

    init(view: HomeView) {
        self.view = view
    }

    func updateView(from storage: HealthActivityStatisticsStorage) {
        let dataSource = makeDataSource(from: storage)

        view?.dataSource = dataSource
    }

    private func makeDataSource(from storage: HealthActivityStatisticsStorage) -> HomeViewDataSource {
        let heartActivity = HeartRateActivityView.ViewModel(heartRate: storage.heartRate, state: .normal)
        let lifeActivity = LifeActivityView.ViewModel(currentStepsCount: storage.stepsCount, goalStepsCount: storage.stepsGoal)
        let calloriesActivity = CalloriesActivityView.ViewModel(currentCalloriesBurnt: storage.burnedCallories, goalCallories: storage.calloriesGoal)
        let switchViewModel = SwitchView.ViewModel(id: "", title: "Statistic monitoring:", isSwitchOn: storage.isTrackingEnabled)

        return .init(activityContext: .init(heartRateViewModel: heartActivity,
                                            lifeViewModel: lifeActivity,
                                            calloriesViewModel: calloriesActivity,
                                            switchViewModel: switchViewModel))
    }

    private func checkIfInteractorSet() {
        if interactor == nil {
            logError(message: "Interactor expected to be set")
        }
    }

}

extension HomePresenterImpl: HomeEventsHandler {

    func didSwitchChangeValue(to value: Bool) {
        checkIfInteractorSet()

        value ? interactor?.startStatisticsTracking() : interactor?.stopStatisticsTracking()
    }

}
