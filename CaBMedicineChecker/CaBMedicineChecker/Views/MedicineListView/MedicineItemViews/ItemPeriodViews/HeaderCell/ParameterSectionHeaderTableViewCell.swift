import UIKit
import CaBUIKit

final class ParameterSectionHeaderTableViewCell: UITableViewCell {
    
    static var nib: UINib {
        return .init(nibName: cellIdentifier, bundle: .medicineChecker)
    }
    
    static var cellIdentifier: String {
        return "ParameterSectionHeaderTableViewCell"
    }
    
    private enum Constants {
        
        static var cornerRadius: CGFloat {
            return 8.0
        }
        
        static var font: UIFont {
            return CaBFont.Comfortaa.bold(size: 20.0)
        }
        
    }
    private var colorScheme: CaBColorScheme = .default
    
    @IBOutlet private weak var headerContainer: UIView!
    @IBOutlet private weak var sectionTitleLabel: UILabel!
    
    func configure(with text: String, _ colorScheme: CaBColorScheme) {
        headerContainer.layer.cornerRadius = Constants.cornerRadius
        headerContainer.backgroundColor = .white
        
        self.colorScheme = colorScheme
        let attributedTitle = NSAttributedString(text: text,
                                                 textColor: colorScheme.highlightPrimaryColor,
                                                 font: Constants.font)
        
        sectionTitleLabel.attributedText = attributedTitle
        
        configureShadow()
    }
    
    private func configureShadow() {
        headerContainer.layer.shadowColor = colorScheme.highlightPrimaryColor.cgColor
        headerContainer.layer.shadowOffset = .zero
        headerContainer.layer.shadowOpacity = 0.2
    }
}
