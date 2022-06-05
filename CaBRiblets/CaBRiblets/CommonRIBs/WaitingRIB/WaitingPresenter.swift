import UIKit

protocol WaitingPresenter: AnyObject {

    func updateView()

}

final class WaitingPresenterImpl: WaitingPresenter {

    weak var view: WaitingView?
    private weak var interactor: WaitingInteractor?

    init(view: WaitingView, interactor: WaitingInteractor?) {
        self.view = view
        self.interactor = interactor
    }

    func updateView() {
        view?.viewModel = makeViewModel()
    }

    private func makeViewModel() -> WaitingView.ViewModel {
        return .init(title: "Wait a little...")
    }

}
