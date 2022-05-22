import CaBRiblets
import CaBFoundation

protocol MedicineItemInfoPresenter: AnyObject {

    func updateView(rawData medicineItem: MedicineItemEntityWrapper, _ periods: [MedicineItemPeriodEntityWrapper])

}

final class MedicineItemInfoPresenterImpl: MedicineItemInfoPresenter {

    typealias PeriodModel = MedicineItemViewModel.Period

    weak var interactor: MedicineItemInfoInteractor?
    weak var view: MedicineItemInfoView?

    init(view: MedicineItemInfoView) {
        self.view = view
    }

    func updateView(rawData medicineItem: MedicineItemEntityWrapper, _ periods: [MedicineItemPeriodEntityWrapper]) {
        let viewModel = makeViewModel(rawData: medicineItem, periods)

        view?.viewModel = viewModel
    }

    private func makeViewModel(rawData medicineItemWrapper: MedicineItemEntityWrapper, _ periodsWrappers: [MedicineItemPeriodEntityWrapper]) -> MedicineItemViewModel {
        let periods: [PeriodModel] = periodsWrappers.map {
            return .init(startDate: $0.startDate,
                         endDate: $0.endDate,
                         frequency: PeriodModel.Frequency(rawValue: $0.frequency),
                         hint: $0.notificationHint)
        }

        return .init(id: medicineItemWrapper.id,
                     barcode: medicineItemWrapper.barcode,
                     marketUrl: URL(string: medicineItemWrapper.marketUrlString),
                     name: medicineItemWrapper.name,
                     imageUrl: URL(string: medicineItemWrapper.imageUrlString),
                     producer: medicineItemWrapper.producer,
                     activeComponent: medicineItemWrapper.activeComponent,
                     periods: periods)
    }

    private func checkIfInteractorSet() {
        if interactor == nil {
            logError(message: "Interactor expected to be set")
        }
    }

}

extension MedicineItemInfoPresenterImpl: MedicineItemInfoViewEventsHandler {

    func didFinish() {
        checkIfInteractorSet()

        interactor?.didFinish()
    }

}
