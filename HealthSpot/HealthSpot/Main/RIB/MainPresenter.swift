import CaBFoundation

// MARK: - Protocol

protocol MainPresenter: AnyObject {

    func updateView(with source: [MainView.Item])

}

// MARK: - Implementation

final class MainPresenterImpl: MainPresenter {

    // MARK: - Private Properties

    private weak var view: MainView?
    private weak var interactor: MainInteractor?

    init(view: MainView, interactor: MainInteractor) {
        self.view = view
        self.interactor = interactor
    }

    // MARK: - Internal Methods

    func updateView(with source: [MainView.Item]) {
        guard let view = view else {
            logError(message: "View Expected to be set")
            return
        }

        view.dataSource = source
    }

    // MARK: - Preivate Methods

    private func checkIfInteractorSet() {
        guard interactor != nil else {
            logError(message: "Interactor expected to be set")
            return
        }
    }

}

// MARK: - Protocol MainViewEventsHandler

extension MainPresenterImpl: MainViewEventsHandler {

    func didSelectTab(with child: MainView.Item) {
        checkIfInteractorSet()

        interactor?.showItem(child)
    }

}
