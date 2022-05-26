import UIKit

open class XibView: UIView {

    // MARK: - Public Class Properties

    open class var defaultFrame: CGRect {
        let size = CGSize(width: 0.0, height: 0.0)
        return CGRect(origin: .zero, size: size)
    }

    // MARK: - Public Class Methods

    open class func makeView() -> XibView {
        return XibView(frame: defaultFrame)
    }

    // MARK: - Public Properties

    open var bundle: Bundle? {
        return .main
    }

    open var nibName: String {
        return String(describing: type(of: self))
    }

    @IBOutlet public weak var mainView: UIView!

    // MARK: - Init

    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    // MARK: - Public Methods

    open func loadView() {
        bundle?.loadNibNamed(nibName, owner: self, options: nil)
        addSubview(mainView)
    }

    open func configureView() {
        /* Do Nothing */
    }

    open func prepareConstraints() {
        mainView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainView.trailingAnchor.constraint(equalTo: trailingAnchor),
            mainView.topAnchor.constraint(equalTo: topAnchor),
            mainView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    // MARK: - Private Methods

    private func commonInit() {
        loadView()
        configureView()
        prepareConstraints()
    }

}
