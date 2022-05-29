import CaBRiblets
import CaBFoundation

protocol MedicineListPresenter: AnyObject {

    func updateView(rawData medicineItems: [CompositeCollectionWrapper<MedicineItemEntityWrapper, MedicineItemPeriodEntityWrapper>], filteredBy date: Date?)

}

final class MedicineListPresenterImpl: MedicineListPresenter {

    typealias PeriodModel = MedicineItemViewModel.Period

    weak var view: MedicineListView?
    weak var interactor: MedicineListInteractor?

    init(view: MedicineListView) {
        self.view = view
    }

    func updateView(rawData medicineItems: [CompositeCollectionWrapper<MedicineItemEntityWrapper, MedicineItemPeriodEntityWrapper>], filteredBy date: Date?) {
        let cellModels: [MedicineItemViewModel]

        if let date = date {
            cellModels = makeViewModels(rawData: medicineItems, filteredBy: date)
        }
        else {
            cellModels = makeViewModels(rawData: medicineItems)
        }

        view?.cellModels = cellModels
    }

    private func makeViewModels(rawData medicineItems: [CompositeCollectionWrapper<MedicineItemEntityWrapper, MedicineItemPeriodEntityWrapper>]) -> [MedicineItemViewModel] {
        let cellModels: [MedicineItemViewModel] = medicineItems.map { medicineItem in
            let periods: [PeriodModel] = medicineItem.second.map {
                return .init(id: $0.id,
                             startDate: $0.startDate,
                             endDate: $0.endDate,
                             frequency: PeriodModel.Frequency(rawValue: $0.frequency),
                             hint: $0.notificationHint,
                             actionType: .add)
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

    private func makeViewModels(rawData medicineItems: [CompositeCollectionWrapper<MedicineItemEntityWrapper, MedicineItemPeriodEntityWrapper>],
                                filteredBy date: Date) -> [MedicineItemViewModel] {
        let cellModels = makeViewModels(rawData: medicineItems)

        var filteredModels = [MedicineItemViewModel]()
        for cellModel in cellModels {
            let rawEvents = Date.getRawEvents(from: cellModel)

            if rawEvents.reduce(false, {
                current, next in current || Date.isEventPossible(expectedDate: date, rawEvent: next)
            }) {
                filteredModels.append(cellModel)
            }
        }

        return filteredModels
    }

    private func checkIfInteractorSet() {
        if interactor == nil {
            logError(message: "Interactor expected to be set")
        }
    }

}

extension MedicineListPresenterImpl: MedicineListViewEventsHandler {

    func didFilterBy(date: Date?) {
        checkIfInteractorSet()

        interactor?.updateDisplyingMedicineItems(filteredBy: date)
    }

    func didTapScanButton() {
        checkIfInteractorSet()

        interactor?.showBarcodeScannerScreen()
    }

    func didSelectRow(with id: String) {
        checkIfInteractorSet()

        interactor?.showMedicineItemInfoScreen(with: id)
    }

}
