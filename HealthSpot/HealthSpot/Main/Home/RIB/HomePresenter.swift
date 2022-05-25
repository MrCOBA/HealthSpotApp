import CaBRiblets
import CaBFoundation

protocol HomePresenter: AnyObject {

    func updateView()

}

final class HomePresenterImpl: HomePresenter {

    weak var view: HomeView?
    weak var interactor: HomeInteractor?

    init(view: HomeView) {
        self.view = view
    }

    func updateView() {
        let dataSource = makeDataSource()

        view?.dataSource = dataSource
    }

    private func makeDataSource() -> HomeViewDataSource {
        return .empty
    }

    private func checkIfInteractorSet() {
        if interactor == nil {
            logError(message: "Interactor expected to be set")
        }
    }

}
