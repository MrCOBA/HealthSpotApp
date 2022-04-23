import UIKit

// TODO: Need modification with label

public class CaBSlider: UISlider, CaBUIControl {

    @IBOutlet weak var sliderValueLabel: UILabel!
    @IBOutlet weak var slider: CaBSlider!

    // MARK: - Overrides

    public override func trackRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(origin: bounds.origin, size: CGSize(width: bounds.width, height: 20))
     }

    // MARK: - Public Methods

    public func apply(configuration: CaBUIConfiguration) {
        configureColors(with: configuration)
        configureBorder(with: configuration)
        configureLayout(with: configuration)
    }

    private func configureColors(with configuration: CaBUIConfiguration) {
        setThumbImage(UIImage.Slider.sliderThumbImage, for: .normal)
        thumbTintColor = configuration.tintColor
        minimumTrackTintColor = configuration.externalColors[0]
        maximumTrackTintColor = configuration.externalColors[1]
    }

    private func configureLayout(with configuration: CaBUIConfiguration) {
        layer.cornerRadius = configuration.cornerRadius
    }

    private func configureBorder(with configuration: CaBUIConfiguration) {
        layer.borderWidth = configuration.borderWidth
        layer.borderColor = configuration.borderColor?.cgColor
    }

}
