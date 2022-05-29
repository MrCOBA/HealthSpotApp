import UIKit
import CaBUIKit
import CaBFoundation

final class AuthorizationInfoViewImpl: UIViewController, AuthorizationView {

    // MARK: - Private Types

    private typealias ButtonType = CaBButtonConfiguration.Default.`Type`

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

    @IBOutlet private weak var backButton: CaBButton!

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var hintLabel: UILabel!
    @IBOutlet private weak var infoImageView: UIImageView!

    @IBOutlet private weak var actionButton: CaBButton!

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
        case .infoFailure,
             .infoSuccess:
            configureTextModel(with: model)
            configureImageView(with: model)
            configureMainActionButton(with: model)

        case .signIn,
             .signUp:
            logError(message: "Unexpected mode: \(model.mode) for main authorization view")
            return
        }
    }

    private func configureTextModel(with model: AuthorizationViewModel) {
        titleLabel.text = model.textModel.title
        hintLabel.text = model.textModel.hint
    }

    private func configureMainActionButton(with model: AuthorizationViewModel) {
        actionButton.setTitle(model.mainActionButtonTitle, for: .normal)

        let buttonType: ButtonType = (model.mode == .infoSuccess) ? .tertiary : .primary
        actionButton.apply(configuration: CaBButtonConfiguration.Default.button(of: buttonType, with: colorScheme))
    }

    private func configureImageView(with model: AuthorizationViewModel) {
        switch model.mode {
        case .infoFailure:
            infoImageView.image = .Autorization.error

        case .infoSuccess:
            infoImageView.image = .Autorization.success

        case .signIn,
             .signUp:
            logError(message: "Unexpected mode: \(model.mode) for info authorization view")
            return
        }
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

    private func checkIfEventsHandlerSet() {
        guard viewModel.eventsHandler != nil else {
            logError(message: "EventsHandler expected to be set")
            return
        }
    }

    // MARK: User Actions

    @IBAction private func mainActionButtonTapped() {
        checkIfEventsHandlerSet()
        viewModel.eventsHandler?.mainActionButtonTap(for: viewModel.mode, with: [:])
    }

    @IBAction private func backButtonTapped() {
        checkIfEventsHandlerSet()
        viewModel.eventsHandler?.backButtonTap()
    }

}

// MARK: - View Factory

extension AuthorizationInfoViewImpl {

    static func makeView() -> AuthorizationInfoViewImpl {
        return UIStoryboard.AuthorizationInfoView.instantiateAuthorizationInfoViewController()
    }

}
