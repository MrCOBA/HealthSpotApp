import UIKit

final class DatePickerContentView: UIView, UIContentView {

    // MARK: - Internal Properties
    
    var configuration: UIContentConfiguration {
        get {
            currentConfiguration
        }
        set {
            guard let newConfiguration = newValue as? ItemPeriodDatePickerContentConfiguration else {
                return
            }
      
            apply(configuration: newConfiguration)
        }
    }
    
    // MARK: - Private Properties
    
    private let datePicker = UIDatePicker()
    private var currentConfiguration: ItemPeriodDatePickerContentConfiguration!
    
    // MARK: - Init
    
    init(configuration: ItemPeriodDatePickerContentConfiguration) {
        super.init(frame: .zero)
        
        setupAllViews()
        apply(configuration: configuration)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    
    private func setupAllViews() {
        datePicker.preferredDatePickerStyle = .wheels
        
        addSubview(datePicker)
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            datePicker.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            datePicker.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            datePicker.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            datePicker.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor),
        ])
    }
    
    private func apply(configuration: ItemPeriodDatePickerContentConfiguration) {
        guard currentConfiguration != configuration else {
            return
        }
        
        currentConfiguration = configuration
        
        if case let MedicineDatePickerItem.picker(date, action) = configuration.item! {
            datePicker.date = date
            datePicker.addAction(action, for: .valueChanged)
        }
    }
    
}
