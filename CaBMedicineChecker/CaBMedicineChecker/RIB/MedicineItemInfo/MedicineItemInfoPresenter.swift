import CaBRiblets
import CaBFoundation

protocol MedicineItemInfoPresenter: AnyObject {

    func updateView(rawData medicineItem: MedicineItemEntityWrapper, _ periods: [MedicineItemPeriodEntityWrapper])

}

final class MedicineItemInfoPresenterImpl: MedicineItemInfoPresenter {

    typealias PeriodModel = MedicineItemViewModel.Period

    weak var interactor: MedicineItemInfoInteractor?
    weak var view: MedicineItemInfoView?

    private let cachedStorage: CachedStorage
    private let rootSettingsStorage: RootSettingsStorage

    init(view: MedicineItemInfoView, cachedStorage: CachedStorage, rootSettingsStorage: RootSettingsStorage) {
        self.view = view
        self.cachedStorage = cachedStorage
        self.rootSettingsStorage = rootSettingsStorage
    }

    func updateView(rawData medicineItem: MedicineItemEntityWrapper, _ periods: [MedicineItemPeriodEntityWrapper]) {
        let viewModel = makeViewModel(rawData: medicineItem, periods)

        view?.viewModel = viewModel
    }

    private func makeViewModel(rawData medicineItemWrapper: MedicineItemEntityWrapper, _ periodsWrappers: [MedicineItemPeriodEntityWrapper]) -> MedicineItemViewModel {
        let periods: [PeriodModel] = periodsWrappers.map {
            return .init(id: $0.id,
                         startDate: $0.startDate,
                         endDate: $0.endDate,
                         frequency: PeriodModel.Frequency(rawValue: $0.frequency),
                         hint: $0.notificationHint,
                         actionType: .add)
        }

        var viewModel = MedicineItemViewModel(id: medicineItemWrapper.id,
                                              barcode: medicineItemWrapper.barcode,
                                              marketUrl: URL(string: medicineItemWrapper.marketUrlString),
                                              name: medicineItemWrapper.name,
                                              imageUrl: URL(string: medicineItemWrapper.imageUrlString),
                                              producer: medicineItemWrapper.producer,
                                              activeComponent: medicineItemWrapper.activeComponent,
                                              periods: periods,
                                              isOfflineModeEnabled: rootSettingsStorage.isOfflineModeOn)

        if let icon = cachedStorage.cache[viewModel.placeholderIconKey] as? Int {
            viewModel.placeholderIcon = .MedicineChecker.placeholderIcon(id: icon)
        }
        else {
            let randomIcon = Int.random(in: 0..<20)
            cachedStorage.cache[viewModel.placeholderIconKey] = randomIcon
            viewModel.placeholderIcon = .MedicineChecker.placeholderIcon(id: randomIcon)
        }

        return viewModel
    }

    private func checkIfInteractorSet() {
        if interactor == nil {
            logError(message: "Interactor expected to be set")
        }
    }

}

extension MedicineItemInfoPresenterImpl: MedicineItemInfoViewEventsHandler {

    func didTapLockedPeriodCell() {
        interactor?.showOfflineModeAlert()
    }

    func didTapPeriodCell(with id: String) {
        interactor?.showItemPeriodScreen(with: .edit(id: id))
    }

    func didTapAddPeriodButton() {
        checkIfInteractorSet()

        interactor?.showItemPeriodScreen(with: .add)
    }

    func didFinish() {
        checkIfInteractorSet()

        interactor?.didFinish()
    }

}
