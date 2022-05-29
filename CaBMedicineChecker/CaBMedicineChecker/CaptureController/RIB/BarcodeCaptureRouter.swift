import UIKit
import CaBRiblets
import CaBFirebaseKit

protocol BarcodeCaptureRouter: ViewableRouter {

    func attachAlert(with error: Error, _ handler: @escaping ((UIAlertAction) -> Void))

}

final class BarcodeCaptureRouterImpl: BaseRouter, BarcodeCaptureRouter {

    var view: UIViewController

    init(view: BarcodeCaptureView, interactor: Interactor) {
        self.view = view
        super.init(interactor: interactor)
    }

    func attachAlert(with error: Error, _ handler: @escaping ((UIAlertAction) -> Void)) {
        let alert: UIAlertController

        guard let error = error as? FirebaseFirestoreMedicineCheckerError else {
            return
        }

        switch error {
        case .noItemFound:
            alert = makeItemNotFoundAlert(with: handler)

        case .itemAlreadyExists:
            alert = makeItemAlreadyExistsAlert(with: handler)

        default:
            return
        }

        view.present(alert, animated: true)
    }

    private func makeItemNotFoundAlert(with handler: @escaping ((UIAlertAction) -> Void)) -> UIAlertController {
        let alert = UIAlertController(title: "Barcode was not found!",
                                      message: "We are working to expand our database...",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: handler))

        return alert
    }

    private func makeItemAlreadyExistsAlert(with handler: @escaping ((UIAlertAction) -> Void)) -> UIAlertController {
        let alert = UIAlertController(title: "Barcode has already exists!",
                                      message: "Try to searching in the calendar on the home screen...",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: handler))

        return alert
    }

}
