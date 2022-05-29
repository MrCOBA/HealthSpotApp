import CaBRiblets
import CaBFoundation
import UIKit

protocol MedicineListPresenter: AnyObject {

    func updateView(rawData medicineItems: [CompositeCollectionWrapper<MedicineItemEntityWrapper, MedicineItemPeriodEntityWrapper>], filteredBy date: Date?)

}

final class MedicineListPresenterImpl: MedicineListPresenter {

    typealias PeriodModel = MedicineItemViewModel.Period

    weak var view: MedicineListView?
    weak var interactor: MedicineListInteractor?

    private let cachedStorage: CachedStorage

    init(view: MedicineListView, cachedStorage: CachedStorage) {
        self.view = view
        self.cachedStorage = cachedStorage
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

            var cellModel: MedicineItemViewModel = .init(id: medicineItem.first.id,
                                                         barcode: medicineItem.first.barcode,
                                                         marketUrl: URL(string: medicineItem.first.marketUrlString),
                                                         name: medicineItem.first.name,
                                                         imageUrl: URL(string: medicineItem.first.imageUrlString),
                                                         producer: medicineItem.first.producer,
                                                         activeComponent: medicineItem.first.activeComponent,
                                                         periods: periods)

            if let icon = cachedStorage.cache[cellModel.placeholderIconKey] as? Int {
                cellModel.placeholderIcon = .MedicineChecker.placeholderIcon(id: icon)
            }
            else {
                let randomIcon = Int.random(in: 0..<20)
                cachedStorage.cache[cellModel.placeholderIconKey] = randomIcon
                cellModel.placeholderIcon = .MedicineChecker.placeholderIcon(id: randomIcon)
            }

            return cellModel
        }

        return cellModels
    }

    private func makeViewModels(rawData medicineItems: [CompositeCollectionWrapper<MedicineItemEntityWrapper, MedicineItemPeriodEntityWrapper>],
                                filteredBy date: Date) -> [MedicineItemViewModel] {
        let cellModels = makeViewModels(rawData: medicineItems)

        var filteredModels = [MedicineItemViewModel]()
        for cellModel in cellModels {
            let rawEvents = Date.getRawEvents(from: cellModel)

            if rawEvents.isEmpty {
                filteredModels.append(cellModel)
                continue
            }
            
            if rawEvents.reduce(false, {
                value, nextEvent in value || Date.isEventPossible(expectedDate: date, rawEvent: nextEvent)
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
