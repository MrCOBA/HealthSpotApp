import UIKit
import CaBUIKit
import CaBSDK

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
    
}
