import UIKit
import CaBUIKit
import CaBSDK

// MARK: - EventsHandler

protocol MedicineItemPeriodViewEventsHandler: AnyObject {

    func didTapAddPeriodButton()
    func didChangeDate(for id: ItemPeriodDatePickerView.ID, to date: Date)
    func didSelectAction(for case: MenuAction)
    func didEndEditingText(for id: Int, with text: String?)

}

struct MedicineItemPeriodViewModel: Equatable {

    let startDate: Date
    let endDate: Date?
    let repeatType: String?
    let notificationHint: String

    static var empty: Self {
        return .init(startDate: Date(), endDate: nil, repeatType: nil, notificationHint: "")
    }

    var toRepeatMenuAction: MenuAction {
        let action = MenuAction.repeatCases.first(where: { $0.rawValue == repeatType }) ?? .noRepeat
        return action
    }

    var toEndDateMenuAction: MenuAction {
        let action: MenuAction = (endDate == nil) ? .noEndDate : .concreteEndDate
        return action
    }

}

final class MedicineItemPeriodView: UIViewController {

    // MARK: - Private Types

    private enum Constants {

        static var font: UIFont {
            return CaBFont.Comfortaa.medium(size: 17.0)
        }

    }

    // MARK: - Internal Properties

    var viewModel: MedicineItemPeriodViewModel = .empty {
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

    // MARK: - Internal Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        configureHintView()
        configure()
    }

    // MARK: - Private Methods

    private func configureHintView() {
        hintInputView = InputView(frame: .zero,
                                  id: 0,
                                  configuration: .Default.general(placeholderText: "helpfull text for notification...", with: colorScheme),
                                  colorScheme: colorScheme)
        hintInputContainerView.addSubview(hintInputView)

        NSLayoutConstraint.activate([
            hintInputView.leadingAnchor.constraint(equalTo: hintInputContainerView.leadingAnchor),
            hintInputView.trailingAnchor.constraint(equalTo: hintInputContainerView.trailingAnchor),
            hintInputView.topAnchor.constraint(equalTo: hintInputContainerView.topAnchor),
            hintInputView.bottomAnchor.constraint(equalTo: hintInputContainerView.bottomAnchor)
        ])

        hintInputView.delegate = self
    }

    private func configure() {
        view.backgroundColor = colorScheme.backgroundPrimaryColor

        configureDatePickerViews()
        configureMenuViews()
        configureHintInput()
        configureAddPeriodButton()
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
        let attributetTitle = NSAttributedString(string: "Notification hint",
                                                 attributes: [
                                                    .foregroundColor: colorScheme.attributesTertiaryColor,
                                                    .font: Constants.font
                                                 ])
        hintTitleLabel.attributedText = attributetTitle
        hintInputView.textField?.text = viewModel.notificationHint
    }

    private func configureAddPeriodButton() {
        addPeriodButton.apply(configuration: CaBButtonConfiguration.Default.button(of: .tertiary, with: colorScheme))
    }

    private func checkIfEventsHandler() {
        if eventsHandler == nil {
            logError(message: "Eventshandler expected to be set")
        }
    }

    @IBAction private func tapAddPeriodButton() {
        checkIfEventsHandler()

        eventsHandler?.didTapAddPeriodButton()
    }

}

// MARK: - Protocol ItemPeriodDatePickerViewDelegate

extension MedicineItemPeriodView: ItemPeriodDatePickerViewDelegate {

    func didChangeDate(for id: ItemPeriodDatePickerView.ID, to date: Date) {
        checkIfEventsHandler()

        eventsHandler?.didChangeDate(for: id, to: date)
    }

}

// MARK: - ItemPeriodMenuViewDelegate

extension MedicineItemPeriodView: ItemPeriodMenuViewDelegate {

    func didSelectAction(for case: MenuAction) {
        checkIfEventsHandler()

        eventsHandler?.didSelectAction(for: `case`)
    }

}

// MARK: - InputViewDelegate

extension MedicineItemPeriodView: InputViewDelegate {

    func didEndEditingText(for id: Int, with text: String?) {
        checkIfEventsHandler()

        eventsHandler?.didEndEditingText(for: id, with: text)
    }

}
