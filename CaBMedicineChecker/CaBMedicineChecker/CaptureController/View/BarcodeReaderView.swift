import UIKit
import AVFoundation

class QRScannerController: UIViewController {

    @IBOutlet var topbar: UIView!
    @IBOutlet var messageLabel: UILabel!

    var captureSession = AVCaptureSession()

    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var qrCodeFrameView: UIView?

    private let supportedCodeTypes = [AVMetadataObject.ObjectType.upce,
                                      AVMetadataObject.ObjectType.code39,
                                      AVMetadataObject.ObjectType.code39Mod43,
                                      AVMetadataObject.ObjectType.code93,
                                      AVMetadataObject.ObjectType.code128,
                                      AVMetadataObject.ObjectType.ean8,
                                      AVMetadataObject.ObjectType.ean13,
                                      AVMetadataObject.ObjectType.aztec,
                                      AVMetadataObject.ObjectType.pdf417,
                                      AVMetadataObject.ObjectType.itf14,
                                      AVMetadataObject.ObjectType.dataMatrix,
                                      AVMetadataObject.ObjectType.interleaved2of5,
                                      AVMetadataObject.ObjectType.qr]

    private var captureController: BarcodeCaptureController?

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let captureDevice = AVCaptureDevice.default(for: AVMediaType.video) else {
            print("Failed to get the camera device")
            return
        }

        do {
            captureController = BarcodeCaptureControllerImpl(supportedCodeTypes: supportedCodeTypes) { [weak self] code in
                self?.launchApp(decodedURL: code)
            }

        } catch {
            print(error)
            return
        }

        guard let captureController = captureController else {
            return
        }
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureController.captureSession)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        videoPreviewLayer?.frame = view.layer.bounds
        view.layer.addSublayer(videoPreviewLayer!)

        captureController.start()

        view.bringSubviewToFront(messageLabel)
        view.bringSubviewToFront(topbar)

        qrCodeFrameView = UIView()

        if let qrCodeFrameView = qrCodeFrameView {
            qrCodeFrameView.layer.borderColor = UIColor.red.cgColor
            qrCodeFrameView.layer.borderWidth = 2
            view.addSubview(qrCodeFrameView)
            view.bringSubviewToFront(qrCodeFrameView)
        }
    }

    // MARK: - Helper methods

    func launchApp(decodedURL: String) {

        if presentedViewController != nil {
            return
        }

        let alertPrompt = UIAlertController(title: "Open App", message: "You're going to open \(decodedURL)", preferredStyle: .actionSheet)
        let confirmAction = UIAlertAction(title: "Confirm", style: UIAlertAction.Style.default, handler: { (action) -> Void in

            if let url = URL(string: decodedURL) {
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url)
                }
            }
        })

        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil)

        alertPrompt.addAction(confirmAction)
        alertPrompt.addAction(cancelAction)

        present(alertPrompt, animated: true, completion: nil)
    }

    private func updatePreviewLayer(layer: AVCaptureConnection, orientation: AVCaptureVideoOrientation) {
        layer.videoOrientation = orientation
        videoPreviewLayer?.frame = self.view.bounds
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        if let connection =  self.videoPreviewLayer?.connection  {
            let currentDevice: UIDevice = UIDevice.current
            let orientation: UIDeviceOrientation = currentDevice.orientation
            let previewLayerConnection : AVCaptureConnection = connection

            if previewLayerConnection.isVideoOrientationSupported {
                switch (orientation) {
                    case .portrait:
                        updatePreviewLayer(layer: previewLayerConnection, orientation: .portrait)
                    case .landscapeRight:
                        updatePreviewLayer(layer: previewLayerConnection, orientation: .landscapeLeft)
                    case .landscapeLeft:
                        updatePreviewLayer(layer: previewLayerConnection, orientation: .landscapeRight)
                    case .portraitUpsideDown:
                        updatePreviewLayer(layer: previewLayerConnection, orientation: .portraitUpsideDown)
                    default:
                        updatePreviewLayer(layer: previewLayerConnection, orientation: .portrait)
                }
            }
        }
    }

}

extension QRScannerController: AVCaptureMetadataOutputObjectsDelegate {

    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
            messageLabel.text = "No QR code is detected"
            return
        }

        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject

        if supportedCodeTypes.contains(metadataObj.type) {
            // If the found metadata is equal to the QR code metadata (or barcode) then update the status label's text and set the bounds
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            qrCodeFrameView?.frame = barCodeObject!.bounds

            if metadataObj.stringValue != nil {
                launchApp(decodedURL: metadataObj.stringValue!)
                messageLabel.text = metadataObj.stringValue
            }
        }
    }

}
