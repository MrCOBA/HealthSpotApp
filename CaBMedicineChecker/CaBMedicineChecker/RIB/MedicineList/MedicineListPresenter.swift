import CaBRiblets
import CaBSDK

protocol MedicineListPresenter: AnyObject {

    func updateView(rawData medicineItems: [CompositeWrapper<MedicineItemEntityWrapper, MedicineItemPeriodEntityWrapper>])

}

final class MedicineListPresenterImpl: MedicineListPresenter {

    typealias PeriodModel = MedicineItemViewModel.Period

    weak var view: MedicineListView?
    weak var interactor: MedicineListInteractor?

    init(view: MedicineListView) {
        self.view = view
    }

    func updateView(rawData medicineItems: [CompositeWrapper<MedicineItemEntityWrapper, MedicineItemPeriodEntityWrapper>]) {
        let cellModels = makeViewModels(rawData: medicineItems)

        view?.cellModels = cellModels
    }

    private func makeViewModels(rawData medicineItems: [CompositeWrapper<MedicineItemEntityWrapper, MedicineItemPeriodEntityWrapper>]) -> [MedicineItemViewModel] {
        let cellModels: [MedicineItemViewModel] = medicineItems.map { medicineItem in
            let periods: [PeriodModel] = medicineItem.second.map {
                return .init(startDate: $0.startDate,
                             endDate: $0.endDate,
                             frequency: PeriodModel.Frequency(rawValue: $0.frequency),
                             hint: $0.notificationHint)
            }

            return .init(id: medicineItem.first.id,
                         barcode: medicineItem.first.barcode,
                         marketUrl: URL(string: medicineItem.first.marketUrlString),
                         name: medicineItem.first.name,
                         imageUrl: URL(string: medicineItem.first.imageUrlString),
                         producer: medicineItem.first.producer,
                         activeComponent: medicineItem.first.activeComponent,
                         periods: periods)
        }

        return cellModels
    }

    private func checkIfInteractorSet() {
        if interactor == nil {
            logError(message: "Interactor expected to be set")
        }
    }

}

extension MedicineListPresenterImpl: MedicineListViewEventsHandler {

    func didTapScanButton() {
        checkIfInteractorSet()

        interactor?.showBarcodeScannerScreen()
    }

    func didSelectRow(with id: String) {
        checkIfInteractorSet()

        interactor?.showMedicineItemInfoScreen(with: id)
    }

}
