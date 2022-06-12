import UIKit
import CaBUIKit
import CaBFoundation

// MARK: - EventsHandler

protocol MedicineItemPeriodViewEventsHandler: AnyObject {

    func didTapPeriodActionButton(_ action: MedicineItemPeriodActionType)
    func didChangeDate(for id: ItemPeriodDatePickerView.ID, to date: Date)
    func didSelectItem(_ item: MenuItem)
    func didEndEditingText(with text: String?)
    func didFinishEditing()

}

final class MedicineItemPeriodView: UIViewController {

    // MARK: - Private Types

    private enum Constants {

        static var font: UIFont {
            return CaBFont.Comfortaa.medium(size: 17.0)
        }

    }

    // MARK: - Internal Properties

    var viewModel: MedicineItemViewModel.Period = .empty {
        didSet {
            if oldValue != viewModel {
                configure()
            }
        }
    }

    var colorScheme: CaBColorScheme = .default

    weak var eventsHandler: MedicineItemPeriodViewEventsHandler?

    // MARK: - Private Properties

    @IBOutlet private weak var startDatePickerView: ItemPeriodDatePickerView!
    @IBOutlet private weak var endDatePickerView: ItemPeriodDatePickerView!
    @IBOutlet private weak var repeatMenuView: ItemPeriodMenuView!
    @IBOutlet private weak var endDateMenuView: ItemPeriodMenuView!

    @IBOutlet private weak var hintTitleLabel: UILabel!
    @IBOutlet private weak var hintInputContainerView: UIView!
    private var hintInputView: InputView!

    @IBOutlet private weak var addPeriodButton: CaBButton!
    @IBOutlet private weak var deletePeriodButton: CaBButton!

    // MARK: - Internal Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        configureHintView()
        configure()
    }

    // MARK: - Private Methods

    private func configureHintView() {
        hintInputView = InputView(frame: hintInputContainerView.frame,
                                  id: 0,
                                  configuration: .Default.general(placeholderText: "helpfull text for notification...", with: colorScheme),
                                  colorScheme: colorScheme)
        hintInputContainerView.addSubview(hintInputView)

        hintInputView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hintInputView.leadingAnchor.constraint(equalTo: hintInputContainerView.leadingAnchor),
            hintInputView.trailingAnchor.constraint(equalTo: hintInputContainerView.trailingAnchor),
            hintInputView.topAnchor.constraint(equalTo: hintInputContainerView.topAnchor),
            hintInputView.bottomAnchor.constraint(equalTo: hintInputContainerView.bottomAnchor)
        ])

        hintInputView.textField?.delegate = self
    }

    private func configure() {
        view.backgroundColor = colorScheme.backgroundPrimaryColor

        configureDatePickerViews()
        configureMenuViews()
        configureHintInput()
        configureBackButton()
        configureAddPeriodButton()
        configureDeletePeriodButton()
    }

    private func configureDatePickerViews() {
        startDatePickerView.delegate = self
        startDatePickerView.configure(for: .startDate, with: colorScheme)
        startDatePickerView.setDate(viewModel.startDate)

        endDatePickerView.delegate = self
        endDatePickerView.configure(for: .endDate, with: colorScheme)
        endDatePickerView.isHidden = (viewModel.endDate == nil)
        if let endDate = viewModel.endDate {
            endDatePickerView.setDate(endDate)
        }

    }

    private func configureMenuViews() {
        repeatMenuView.delegate = self
        repeatMenuView.configure(for: .repeatMenu, with: colorScheme)
        repeatMenuView.setItem(to: viewModel.toRepeatMenuAction)

        endDateMenuView.delegate = self
        endDateMenuView.configure(for: .endDateMenu, with: colorScheme)
        endDateMenuView.setItem(to: viewModel.toEndDateMenuAction)
    }

    private func configureHintInput() {
        let attributetTitle = NSAttributedString(text: "Notification hint",
                                                 textColor: colorScheme.attributesTertiaryColor,
                                                 font: Constants.font)
        hintTitleLabel.attributedText = attributetTitle
        hintInputView.textField?.text = viewModel.hint
    }

    private func configureBackButton() {
        let backBarButton = UIBarButtonItem(title: "Back",
                                            style: .plain,
                                            target: self,
                                            action: #selector(backButtonPressed))
        let attrs = [
            NSAttributedString.Key.font: CaBFont.Comfortaa.bold(size: 16),
            NSAttributedString.Key.foregroundColor: colorScheme.highlightPrimaryColor
        ]
        backBarButton.setTitleTextAttributes(attrs, for: .normal)
        navigationItem.leftBarButtonItem = backBarButton
    }

    private func configureAddPeriodButton() {
        addPeriodButton.apply(configuration: CaBButtonConfiguration.Default.button(of: .tertiary, with: colorScheme))
        addPeriodButton.setTitle("Apply", for: .normal)
    }

    private func configureDeletePeriodButton() {
        deletePeriodButton.isHidden = (viewModel.actionType == .add)
        deletePeriodButton.apply(configuration: CaBButtonConfiguration.Service.noticeButton(with: colorScheme, icon: nil))
        deletePeriodButton.setTitle("Delete", for: .normal)
    }

    private func checkIfEventsHandlerSet() {
        if eventsHandler == nil {
            logError(message: "Eventshandler expected to be set")
        }
    }

    @objc
    private func backButtonPressed() {
        checkIfEventsHandlerSet()

        eventsHandler?.didFinishEditing()
    }

    @IBAction private func tapEditPeriodActionButton() {
        checkIfEventsHandlerSet()

        eventsHandler?.didTapPeriodActionButton(viewModel.actionType)
    }

    @IBAction private func tapDeletePeriodActionButton() {
        checkIfEventsHandlerSet()

        eventsHandler?.didTapPeriodActionButton(.delete(id: viewModel.id))
    }

}

// MARK: - Protocol UITextFieldDelegate

extension MedicineItemPeriodView: UITextFieldDelegate {

    func textFieldDidBeginEditing(_ textField: UITextField) {
        endDateMenuView.isHidden = true
    }

    public func textFieldDidEndEditing(_ textField: UITextField) {
        endDateMenuView.isHidden = false

        eventsHandler?.didEndEditingText(with: textField.text)
    }

    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return false
    }

}

// MARK: - Protocol ItemPeriodDatePickerViewDelegate

extension MedicineItemPeriodView: ItemPeriodDatePickerViewDelegate {

    func didChangeDate(for id: ItemPeriodDatePickerView.ID, to date: Date) {
        checkIfEventsHandlerSet()

        eventsHandler?.didChangeDate(for: id, to: date)
    }

}

// MARK: - ItemPeriodMenuViewDelegate

extension MedicineItemPeriodView: ItemPeriodMenuViewDelegate {

    func didSelectItem(_ item: MenuItem) {
        checkIfEventsHandlerSet()

        eventsHandler?.didSelectItem(item)
    }

}

// MARK: - Helper

extension MedicineItemViewModel.Period {

    fileprivate var toRepeatMenuAction: MenuItem {
        let action = MenuItem.repeatCases.first(where: { $0.rawValue == frequency?.rawValue }) ?? .noRepeat
        return action
    }

    fileprivate var toEndDateMenuAction: MenuItem {
        let action: MenuItem = (endDate == nil) ? .noEndDate : .concreteEndDate
        return action
    }

}

// MARK: - View Factory

extension MedicineItemPeriodView {

    static func makeView() -> MedicineItemPeriodView {
        return UIStoryboard.MedicineItemPeriodView.instantiateMedicineItemPeriodViewController()
    }

}
