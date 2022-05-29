import CaBFoundation

// MARK: - Protocol

protocol MedicineItemPeriodPresenter: AnyObject {

    func updateView(for actionType: MedicineItemPeriodActionType)

}

// MARK: - Implementation

final class MedicineItemPeriodPresenterImpl: MedicineItemPeriodPresenter {

    // MARK: - Internal Properties

    weak var interactor: MedicineItemPeriodInteractor?
    weak var view: MedicineItemPeriodView?

    // MARK: - Private Properties

    private let storage: MedicineItemPeriodTemporaryStorage

    // MARK: - Init

    init(view: MedicineItemPeriodView, storage: MedicineItemPeriodTemporaryStorage) {
        self.view = view
        self.storage = storage
    }

    // MARK: - Internal Methods

    func updateView(for actionType: MedicineItemPeriodActionType) {
        view?.viewModel = makeViewModel(for: actionType)
    }

    // MARK: - Private Methods

    private func makeViewModel(for actionType: MedicineItemPeriodActionType) -> MedicineItemViewModel.Period {
        return .init(id: storage.id,
                     startDate: storage.startDate,
                     endDate: storage.endDate,
                     frequency: .init(rawValue: storage.frequency ?? ""),
                     hint: storage.notificationHint,
                     actionType: actionType)
    }

    private func checkIfInteractorSet() {
        if interactor == nil {
            logError(message: "Interactor expected to be set")
        }
    }

}

// MARK: - Protocol MedicineItemPeriodViewEventsHandler

extension MedicineItemPeriodPresenterImpl: MedicineItemPeriodViewEventsHandler {

    func didTapPeriodActionButton(_ action: MedicineItemPeriodActionType) {
        checkIfInteractorSet()

        interactor?.updatePeriod(with: action)
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

    func didSelectItem(_ item: MenuItem) {
        checkIfInteractorSet()

        switch item {
        case .noEndDate:
            interactor?.updateStorage(.endDate, with: nil)

        case .concreteEndDate:
            interactor?.updateStorage(.endDate, with: Date())

        case .daily,
             .weekly,
             .monthly,
             .yearly:
            interactor?.updateStorage(.frequency, with: item.rawValue)

        case .noRepeat:
            interactor?.updateStorage(.frequency, with: nil)

        default:
            logError(message: "Unknown action provided: <\(item.rawValue)>")
        }
    }

    func didEndEditingText(with text: String?) {
        checkIfInteractorSet()

        interactor?.updateStorage(.notificationHint, with: text)
    }

    func didFinishEditing() {
        checkIfInteractorSet()

        interactor?.cancelUpdatePeriod()
    }

}
