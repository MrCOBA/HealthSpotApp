import UIKit

public class CaBSwitch: UISwitch, CaBUIControl {

    // MARK: - Public Methods

    public func apply(configuration: CaBUIConfiguration) {
        configureLayout()
        configureColors(with: configuration)
        configureBorder(with: configuration)
    }

    // MARK: - Private Methods
    
    private func configureLayout() {
        layer.cornerRadius = frame.height / 2
    }

    private func configureColors(with configuration: CaBUIConfiguration) {
        backgroundColor = configuration.backgroundColor
        onTintColor = configuration.externalColors.first
        thumbTintColor = configuration.tintColor
    }

    private func configureBorder(with configuration: CaBUIConfiguration) {
        layer.borderWidth = 2
        layer.borderColor = configuration.tintColor?.cgColor
    }

}
