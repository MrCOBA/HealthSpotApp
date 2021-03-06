import UIKit
import AVFoundation
import CaBFoundation

protocol BarcodeCaptureEventsHandler: AnyObject {

    func didCaptureCancel()
    func handleReceivedBarcode(_ barcode: String)

}

final class BarcodeCaptureView: UIViewController, DismissablePresentationControllerConfigurator {

    // MARK: - Internal Properties

    weak var eventsHandler: BarcodeCaptureEventsHandler?
    var adaptivePresentationProxy: AdaptivePresentationDelegateProxy?

    // MARK: - Private Properties

    @IBOutlet private weak var messageLabel: UILabel!

    private var captureSession = AVCaptureSession()
    private var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    private var qrCodeFrameView: UIView?
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

    // MARK: - Internal Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        configureCaptureSession()
        configurePreviewLaayer()

        captureSession.startRunning()

        configureViews()
        configurePresentationController()
    }

    // MARK: - Private Methods

    private func configureCaptureSession() {
        guard let captureDevice = AVCaptureDevice.default(for: AVMediaType.video) else {
            logError(message: "Failed to get the camera device")
            return
        }

        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            captureSession.addInput(input)
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession.addOutput(captureMetadataOutput)
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = supportedCodeTypes
        } catch {
            logError(message: "Error occurred during video capture: <\(error.localizedDescription)>")
            return
        }
    }

    private func configurePreviewLaayer() {
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        videoPreviewLayer?.frame = view.layer.bounds
        view.layer.addSublayer(videoPreviewLayer!)
    }

    private func configureViews() {
        view.bringSubviewToFront(messageLabel)
        qrCodeFrameView = UIView()

        if let qrCodeFrameView = qrCodeFrameView {
            qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
            qrCodeFrameView.layer.borderWidth = 2
            view.addSubview(qrCodeFrameView)
            view.bringSubviewToFront(qrCodeFrameView)
        }
    }

    private func updatePreviewLayer(layer: AVCaptureConnection, orientation: AVCaptureVideoOrientation) {
        layer.videoOrientation = orientation
        videoPreviewLayer?.frame = self.view.bounds
    }

    private func checkIfEventsHandlerSet() {
        if eventsHandler == nil {
            logError(message: "Eventshandler expected to be set")
        }
    }

}

// MARK: - Protocol AVCaptureMetadataOutputObjectsDelegate

extension BarcodeCaptureView: AVCaptureMetadataOutputObjectsDelegate {

    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if metadataObjects.isEmpty {
            qrCodeFrameView?.frame = CGRect.zero
            messageLabel.text = "No QR code is detected"
            return
        }

        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject

        if supportedCodeTypes.contains(metadataObj.type) {
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            qrCodeFrameView?.frame = barCodeObject!.bounds

            if metadataObj.stringValue != nil {
                messageLabel.text = metadataObj.stringValue

                checkIfEventsHandlerSet()
                captureSession.stopRunning()
                eventsHandler?.handleReceivedBarcode(metadataObj.stringValue!)
            }
        }
    }

}

// MARK: - Protocol PresentationControllerDismissHandlerDelegate

extension BarcodeCaptureView: PresentationControllerDismissHandlerDelegate {

    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        checkIfEventsHandlerSet()
        eventsHandler?.didCaptureCancel()
    }

}

// MARK: - View Factory

extension BarcodeCaptureView {

    static func makeView() -> BarcodeCaptureView {
        UIStoryboard.BarcodeCaptureView.instantiateBarcodeCaptureViewController()
    }

}

