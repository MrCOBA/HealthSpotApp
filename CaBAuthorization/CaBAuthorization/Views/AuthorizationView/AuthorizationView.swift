import UIKit
import CaBUIKit
import CaBFoundation

public protocol AuthorizationView: AnyObject {

    var viewModel: AuthorizationViewModel { get set }
    var eventsHandler: AutorizationEventsHandler? { get set }

}

final class AuthorizationViewImpl: UIViewController, AuthorizationView {

    // MARK: - Private Types

    private enum Constant {

        static var inputStackViewItemSpacing: CGFloat {
            return 16.0
        }

        static var titleLargeStackViewItemSpacing: CGFloat {
            return 10.0
        }

        static var titleSmallStackViewItemSpacing: CGFloat {
            return 0.0
        }

    }

    // MARK: - Internal Properties

    var viewModel: AuthorizationViewModel = .empty {
        didSet {
            if oldValue != viewModel {
                updateView(with: viewModel)
            }
        }
    }

    var colorScheme: CaBColorScheme = .default {
        didSet {
            updateView(with: viewModel)
        }
    }

    weak var eventsHandler: AutorizationEventsHandler?

    // MARK: - Private Properties

    // MARK: Outlets

    @IBOutlet private weak var backButton: CaBButton!

    @IBOutlet private weak var titleStackView: UIStackView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!
    @IBOutlet private weak var hintLabel: UILabel!

    @IBOutlet private weak var inputStackView: UIStackView!

    @IBOutlet private weak var actionButton: CaBButton!
    @IBOutlet private weak var additionalActionButton: CaBButton!

    private var underlyingCredentials = [Int: String]()

    // MARK: - Internal Methods

    // MARK: Overrides

    override func viewDidLoad() {
        super.viewDidLoad()

        updateView(with: viewModel)
    }

    // MARK: - Private Methods

    private func updateView(with model: AuthorizationViewModel) {
        view.backgroundColor = colorScheme.backgroundPrimaryColor

        switch model.mode {
        case .signIn:
            configureSignIn()

        case .signUp:
            configureSignUp()

        case .infoFailure,
             .infoSuccess:
            logError(message: "Unexpected mode: \(model.mode) for main authorization view")
            return
        }

        configureTextModel(with: model)
        configureInputStackView(with: model)
        configureMainActionButton(with: model)
        configureAdditionalActionButton(with: model)
        configureBackButton(with: model)
    }

    private func configureSignIn() {
        titleLabel.isHidden = false
        subtitleLabel.isHidden = false
        hintLabel.isHidden = false
    }

    private func configureSignUp() {
        titleLabel.isHidden = true
        subtitleLabel.isHidden = false
        hintLabel.isHidden = true
    }

    private func configureTextModel(with model: AuthorizationViewModel) {
        titleStackView.setCustomSpacing(Constant.titleSmallStackViewItemSpacing, after: titleLabel)
        titleStackView.setCustomSpacing(Constant.titleLargeStackViewItemSpacing, after: subtitleLabel)

        titleLabel.text = model.textModel.title
        subtitleLabel.text = model.textModel.subtitle
        hintLabel.text = model.textModel.hint
    }

    private func configureMainActionButton(with model: AuthorizationViewModel) {
        actionButton.setTitle(model.mainActionButtonTitle, for: .normal)
        actionButton.apply(configuration: CaBButtonConfiguration.Default.button(of: .primary, with: colorScheme))
    }

    private func configureAdditionalActionButton(with model: AuthorizationViewModel) {
        if case .shown(let title) = model.additionalActionButtonState {
            additionalActionButton.isHidden = false
            additionalActionButton.setTitle(title, for: .normal)
            additionalActionButton.apply(configuration: CaBButtonConfiguration.Default.button(of: .secondary, with: colorScheme))
            return
        }

        additionalActionButton.isHidden = true
    }

    private func configureBackButton(with model: AuthorizationViewModel) {
        if case .shown(let title) = model.backButtonState {
            backButton.isHidden = false
            backButton.setTitle(title, for: .normal)
            backButton.apply(configuration: CaBButtonConfiguration.Service.generalButton(with: colorScheme, icon: .Autorization.back))
            backButton.imageView?.tintColor = colorScheme.highlightPrimaryColor
            return
        }

        backButton.isHidden = true
    }

    private func configureInputStackView(with model: AuthorizationViewModel) {
        inputStackView.spacing = Constant.inputStackViewItemSpacing
        inputStackView.removeArrangedSubviews()

        model.inputTextFieldsStates.enumerated().forEach {
            if let inputView = configureInputTextField(for: $0.element, with: $0.offset) {
                inputStackView.addArrangedSubview(inputView)
                inputView.delegate = self
            }
        }
    }

    private func configureInputTextField(for state: AuthorizationViewModel.InputTextFieldState, with id: Int) -> InputView? {
        if case .shown(let placeholder, let icon) = state {
            let view: InputView = .init(frame: .zero,
                                        id: id,
                                        configuration: .Default.general(placeholderText: placeholder, with: colorScheme),
                                        icon: icon,
                                        colorScheme: colorScheme)
            if id == 0 {
                view.textField?.keyboardType = .emailAddress
                view.textField?.autocorrectionType = .no
            }
            else {
                view.textField?.isSecureTextEntry = true
            }

            return view
        }
        return nil
    }

    private func checkIfEventsHandlerSet() {
        guard eventsHandler != nil else {
            logError(message: "EventsHandler expected to be set")
            return
        }
    }

    // MARK: User Actions

    @IBAction private func mainActionButtonTapped() {
        checkIfEventsHandlerSet()
        eventsHandler?.mainActionButtonTap(for: viewModel.mode, with: underlyingCredentials)
    }

    @IBAction private func additionalActionButtonTapped() {
        checkIfEventsHandlerSet()
        eventsHandler?.additionalActionButtonTap(for: viewModel.mode)
    }

    @IBAction private func backButtonTapped() {
        checkIfEventsHandlerSet()
        eventsHandler?.backButtonTap()
    }

}

// MARK: - Protocol InputViewDelegate

extension AuthorizationViewImpl: InputViewDelegate {

    func didEndEditingText(for id: Int, with text: String?) {
        underlyingCredentials[id] = text ?? ""
    }

}

// MARK: - View Factory

extension AuthorizationViewImpl {

    static func makeView() -> AuthorizationViewImpl {
        return UIStoryboard.AuthorizationView.instantiateAuthorizationViewController()
    }

}
