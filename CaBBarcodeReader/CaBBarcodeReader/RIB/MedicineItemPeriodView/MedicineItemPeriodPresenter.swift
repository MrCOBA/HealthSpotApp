import CaBSDK

final class MedicineItemPeriodPresenter {

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

}

extension MedicineItemPeriodPresenter: MedicineItemPeriodViewEventsHandler {

    func didTapAddPeriodButton() {

    }

    func didChangeDate(for id: ItemPeriodDatePickerView.ID, to date: Date) {

    }

    func didSelectAction(for case: MenuAction) {

    }

    func didEndEditingText(for id: Int, with text: String?) {
        
    }

}
