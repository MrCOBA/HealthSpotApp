import UIKit

class PeriodParameterContainerViewCell: UITableViewCell {
    
    // MARK: - Private Types
    
    private enum Constants {
        
        static var cornerRadius: CGFloat {
            return 8.0
        }
        
    }
    
    // MARK: - Internal Properties
    
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: - Private Properties
    
    @IBOutlet private weak var containerView: UIView!
    
    // MARK: - Internal Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configure()
    }
    
    // MARK: - Private Methods
    
    private func configure() {
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = Constants.cornerRadius
    }
    
}
