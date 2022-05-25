import UIKit
import CaBUIKit
import CaBFoundation

protocol SwitchViewDelegate: AnyObject {

    func didChangeValue(_ value: Bool)

}

final class SwitchView: XibView {

    struct ViewModel: Equatable {

        let id: String
        let title: String?
        let isSwitchOn: Bool

        static var empty: Self {
            return .init(id: "", title: nil, isSwitchOn: false)
        }

    }

    weak var delegate: SwitchViewDelegate?

    var colorScheme: CaBColorScheme = .default {
        didSet {
            configure(with: viewModel)
        }
    }

    var viewModel: ViewModel = .empty {
        didSet {
            if oldValue != viewModel {
                configure(with: viewModel)
            }
        }
    }

    @IBOutlet private weak var switchTitleLabel: UILabel!
    @IBOutlet private weak var activitySwitch: CaBSwitch!

    override func configureView() {
        super.configureView()

        configure(with: viewModel)
    }

    private func configure(with viewModel: ViewModel) {
        activitySwitch.apply(configuration: CaBSwitchConfiguration.Default.general(with: colorScheme))
        activitySwitch.isOn = viewModel.isSwitchOn

        let attributedTitle = NSAttributedString(text: viewModel.title ?? "",
                                                 textColor: colorScheme.highlightPrimaryColor,
                                                 font: CaBFont.Comfortaa.bold(size: 15.0))
        switchTitleLabel.attributedText = attributedTitle
    }

    @IBAction func didChangeValue(_ sender: Any) {
        guard delegate != nil else {
            logError(message: "Error was obtained")
            return
        }

        delegate?.didChangeValue(activitySwitch.isOn)
    }

}
