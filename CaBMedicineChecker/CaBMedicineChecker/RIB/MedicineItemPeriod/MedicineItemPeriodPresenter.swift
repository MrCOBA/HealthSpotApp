import CaBSDK

// MARK: - Protocol

protocol MedicineItemPeriodPresenter: AnyObject {

    func updateView()

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

    func updateView() {
        view?.viewModel = makeViewModel()
    }

    // MARK: - Private Methods

    private func makeViewModel() -> MedicineItemViewModel.Period {
        return .init(startDate: storage.startDate,
                     endDate: storage.endDate,
                     frequency: .init(rawValue: storage.frequency ?? ""),
                     hint: storage.notificationHint)
    }

    private func checkIfInteractorSet() {
        if interactor == nil {
            logError(message: "Interactor expected to be set")
        }
    }

}

// MARK: - Protocol MedicineItemPeriodViewEventsHandler

extension MedicineItemPeriodPresenterImpl: MedicineItemPeriodViewEventsHandler {

    func didTapAddPeriodButton() {
        checkIfInteractorSet()

        interactor?.updatePeriod()
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

        case .daily,
             .weekly,
             .monthly,
             .yearly:
            interactor?.updateStorage(.frequency, with: action.rawValue)

        case .noRepeat:
            interactor?.updateStorage(.frequency, with: nil)

        default:
            logError(message: "Unknown action provided: <\(action.rawValue)>")
        }
    }

    func didEndEditingText(for id: Int, with text: String?) {
        checkIfInteractorSet()

        interactor?.updateStorage(.notificationHint, with: text)
    }

    func didFinishEditing() {
        checkIfInteractorSet()

        interactor?.cancelUpdatePeriod()
    }

}
