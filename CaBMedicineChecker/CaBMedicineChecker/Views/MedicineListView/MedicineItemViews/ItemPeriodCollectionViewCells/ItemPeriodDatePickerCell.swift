import UIKit

// MARK: - Cell Configuration

struct ItemPeriodDatePickerContentConfiguration: UIContentConfiguration, Hashable {

    var item: MedicineDatePickerItem?
    
    func makeContentView() -> UIView & UIContentView {
        return DatePickerContentView(configuration: self)
    }
    
    func updated(for state: UIConfigurationState) -> Self {
        return self
    }
    
}

// MARK: - Cell

final class ItemPeriodDatePickerCell: UICollectionViewCell {
    
    // MARK: - Internal Properties
    
    var item: MedicineDatePickerItem?
    
    // MARK: - Internal Methods
    
    override func updateConfiguration(using state: UICellConfigurationState) {
        var newConfiguration = ItemPeriodDatePickerContentConfiguration().updated(for: state)
        newConfiguration.item = item
        
        contentConfiguration = newConfiguration
    }
    
}
