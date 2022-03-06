import Foundation
import CaBSDK
import CaBUIKit
import UIKit

public final class AuthorizationView: UIViewController {

    // MARK: - Private Types

    private typealias TextFieldDataSource = (textField: CaBTextField, state: AuthorizationViewModel.InputTextFieldState)
    private typealias CredentialsDataSource = [AuthorizationViewModel.Key : String]

    // MARK: - Public Properties

    public var viewModel: AuthorizationViewModel = .empty {
        didSet {
            if oldValue != viewModel {
                updateView(with: viewModel)
            }
        }
    }

    public var colorScheme: CaBColorScheme = .default {
        didSet {
            updateView(with: viewModel)
        }
    }

    // MARK: - Private Properties


    @IBOutlet private weak var modeImageView: UIImageView!
    @IBOutlet private weak var emailTextField: CaBTextField!
    @IBOutlet private weak var passwordTextField: CaBTextField!
    @IBOutlet private weak var repeatPasswordTextField: CaBTextField!
    @IBOutlet private weak var mainActionButton: CaBButton!
    @IBOutlet private weak var additionalActionButton: CaBButton!

    // MARK: - Public Methods

    public override func viewDidLoad() {
        super.viewDidLoad()

        updateView(with: viewModel)
    }

    // MARK: - Private Methods

    private func updateView(with viewModel: AuthorizationViewModel) {
        view.backgroundColor = colorScheme.backgroundPrimaryColor

        modeImageView.image = .image(for: viewModel.mode)
        modeImageView.tintColor = colorScheme.activeSecondaryColor

        configureMainActionButton(with: viewModel)
        configureAdditionalActionButton(with: viewModel)
        configureTextFields(with: viewModel)
    }

    private func configureMainActionButton(with viewModel: AuthorizationViewModel) {
        mainActionButton.apply(configuration: CaBButtonConfiguration.Default.secondaryButton(with: colorScheme))
        mainActionButton.setTitle(viewModel.mainActionButtonTitle, for: .normal)
    }

    private func configureAdditionalActionButton(with viewModel: AuthorizationViewModel) {
        additionalActionButton.isHidden = (viewModel.additionalActionButtonState == .hidden)

        switch viewModel.additionalActionButtonState {
            case .hidden:
                return

            case let .shown(title):
                additionalActionButton.apply(configuration: CaBButtonConfiguration.Default.primaryButton(with: colorScheme))
                additionalActionButton.setTitle(title, for: .normal)
        }
    }

    private func configureTextFields(with viewModel: AuthorizationViewModel) {
        viewModel.textFields.forEach { type in
            configureTextField(of: type)
        }
    }

    private func configureTextField(of type: AuthorizationViewModel.TextField) {
        let configuration = CaBTextFieldConfiguration.Default.general(with: colorScheme)
        let dataSource = toTextField(from: type)

        dataSource.textField.isHidden = (dataSource.state == .hidden)

        switch dataSource.state {
            case let .shown(placeholder):
                dataSource.textField.apply(configuration: configuration)

                let attributedPlaceholder = NSAttributedString(string: placeholder,
                                                               attributes: [
                                                                .font: configuration.font,
                                                                .foregroundColor: UIColor.transparentGray50Alpha
                                                               ])
                dataSource.textField.attributedPlaceholder = attributedPlaceholder

            case .hidden:
                break
        }
    }

    private func toTextField(from type:AuthorizationViewModel.TextField) -> TextFieldDataSource {
        switch type {
            case let .email(state):
                return (emailTextField, state)

            case let .password(state):
                return (passwordTextField, state)

            case let .repeatPassword(state):
                return (repeatPasswordTextField, state)
        }
    }

    private func makeCredentials() -> CredentialsDataSource {
        var credentials = CredentialsDataSource()

        credentials[.email] = emailTextField.text
        credentials[.password] = passwordTextField.text

        guard viewModel.mode == .signUp else {
            return credentials
        }

        credentials[.repeatedPassword] = repeatPasswordTextField.text

        return credentials
    }

    // MARK: User Actions

    @IBAction private func mainActionButtonTapped() {
        guard let eventsHandler = viewModel.eventsHandler else {
            // TODO: Add Log
            return
        }

        eventsHandler.mainActionButtonTap(data: makeCredentials())
    }

    @IBAction private func additionalActionButtonTapped() {
        guard let eventsHandler = viewModel.eventsHandler else {
            // TODO: Add Log
            return
        }

        eventsHandler.additionalActionButtonTap()
    }

}

// MARK: - Helper

extension UIImage {

    fileprivate static func image(for mode: AuthorizationViewModel.Mode) -> UIImage {
        switch mode {
            case .signIn:
                return .Autorization.user

            case .signUp:
                return .Autorization.newUser
        }
    }

}
