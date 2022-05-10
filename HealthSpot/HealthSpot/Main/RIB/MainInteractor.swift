import CaBRiblets

protocol MainInteractor: Interactor {

}

final class MainInteractorImpl: BaseInteractor, MainInteractor {
    
}

extension MainInteractorImpl: MainViewEventsHandler {

    func didSelectTab(with child: MainView.Item) {

    }

}
