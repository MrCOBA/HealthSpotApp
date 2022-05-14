import CaBSDK

protocol MedicineItemPeriodPresenter: AnyObject {

    func updateView()

}

final class MedicineItemPeriodPresenterImpl: MedicineItemPeriodPresenter {

    weak var view: MedicineItemPeriodView?

    private weak var interactor: MedicineItemPeriodInteractor?
    private let storage: MedicineItemPeriodTemporaryStorage

    init(view: MedicineItemPeriodView, interactor: MedicineItemPeriodInteractor, storage: MedicineItemPeriodTemporaryStorage) {
        self.view = view
        self.interactor = interactor
        self.storage = storage
    }

    func updateView() {
        view?.viewModel = makeViewModel()
    }

    private func makeViewModel() -> MedicineItemPeriodViewModel {
        return .init(startDate: storage.startDate,
                     endDate: storage.endDate,
                     repeatType: storage.repeatType,
                     notificationHint: storage.notificationHint)
    }

    private func checkIfInteractorSet() {
        if interactor == nil {
            logError(message: "Interactor expected to be set")
        }
    }

}

extension MedicineItemPeriodPresenterImpl: MedicineItemPeriodViewEventsHandler {

    func didTapAddPeriodButton() {
        checkIfInteractorSet()

        interactor?.addNewPeriod()
    }

    func didChangeDate(for id: ItemPeriodDatePickerView.ID, to date: Date) {
        checkIfInteractorSet()

        switch id {
        case .startDate:
            interactor?.updateStorage(.startDate, with: date)

        case .endDate:
            interactor?.updateStorage(.endDate, with: date)
        }
    }

    func didSelectAction(for action: MenuAction) {
        checkIfInteractorSet()

        switch action {
        case .noEndDate:
            interactor?.updateStorage(.endDate, with: nil)

        case .concreteEndDate:
            interactor?.updateStorage(.endDate, with: Date())

        case .noRepeat,
             .daily,
             .weekly,
             .monthly,
             .yearly:
            interactor?.updateStorage(.repeatType, with: action.rawValue)

        default:
            logError(message: "Unknown action provided: <\(action.rawValue)>")
        }
    }

    func didEndEditingText(for id: Int, with text: String?) {
        checkIfInteractorSet()

        interactor?.updateStorage(.notificationHint, with: text)
    }

}
