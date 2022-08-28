import UIKit
import CaBUIKit
import CaBFoundation

protocol InputParameterPeriodViewDelegate: AnyObject {

    func didEndEditing(with text: String?)

}

final class ParameterInputTableViewCell: PeriodParameterContainerViewCell {
    
    // MARK: - Private Types
    
    private enum Constants {

        static var font: UIFont {
            return CaBFont.Comfortaa.light(size: 12.0)
        }

    }
    
    // MARK: - Private Properties
    
    @IBOutlet private weak var inputContainerView: UIView!
    
    // MARK: - Internal Properties
    
    static var nib: UINib {
        return .init(nibName: cellIdentifier, bundle: .medicineChecker)
    }
    
    static var cellIdentifier: String {
        return "ParameterInputTableViewCell"
    }
    
    private var inputParameterView: InputView!
    
    weak var delegate: InputParameterPeriodViewDelegate?
    var colorScheme: CaBColorScheme = .default
    
    // MARK: - Internal Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configure()
    }
    
    func configure(with text: String, _ colorScheme: CaBColorScheme) {
        self.colorScheme = colorScheme
        inputParameterView.textField?.text = text
    }
    
    // MARK: - Private Properties
    
    private func configure() {
        inputParameterView = InputView(frame: .zero,
                                       id: 0,
                                       configuration: .Default.general(with: colorScheme),
                                       colorScheme: colorScheme)
        
        let attributedTitle = NSAttributedString(text: "Notification Hint",
                                                 textColor: colorScheme.highlightPrimaryColor,
                                                 font: Constants.font)
        titleLabel.attributedText = attributedTitle
        
        inputContainerView.addSubview(inputParameterView)
        inputParameterView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            inputContainerView.leadingAnchor.constraint(equalTo: inputParameterView.leadingAnchor),
            inputContainerView.trailingAnchor.constraint(equalTo: inputParameterView.trailingAnchor),
            inputContainerView.topAnchor.constraint(equalTo: inputParameterView.topAnchor),
            inputContainerView.bottomAnchor.constraint(equalTo: inputParameterView.bottomAnchor)
        ])
    }
    
}

extension ParameterInputTableViewCell: InputViewDelegate {
    
    func didEndEditingText(for id: Int, with text: String?) {
        delegate?.didEndEditing(with: text)
    }
    
}
