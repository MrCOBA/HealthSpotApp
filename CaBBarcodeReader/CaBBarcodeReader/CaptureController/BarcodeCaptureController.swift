import AVFoundation
import CaBSDK

// MARK: - Protocol

public protocol BarcodeCaptureController: AnyObject {
    var captureSession: AVCaptureSession { get set }
    
    func start()
    func stop()
}

// MARK: - Implementation

public final class BarcodeCaptureControllerImpl: NSObject, BarcodeCaptureController, AVCaptureMetadataOutputObjectsDelegate {

    // MARK: - Public Types

    public typealias BarcodeObjectType = AVMetadataObject.ObjectType
    public typealias CodeHandler = ((String) -> Void)

    // MARK: - Private Properties

    public var captureSession: AVCaptureSession
    private let supportedCodeTypes: [BarcodeObjectType]
    private var codeHandler: CodeHandler?

    // MARK: - Init & Deinit

    public init(supportedCodeTypes: [BarcodeObjectType], codeHandler: CodeHandler? = nil) {
        captureSession = AVCaptureSession()

        self.supportedCodeTypes = supportedCodeTypes
        self.codeHandler = codeHandler
    }

    // MARK: - Public Methods

    // MARK: Protocol BarcodeCaptureController

    public func start() {
        configureCaptureSession()
        captureSession.startRunning()
    }

    public func stop() {
        captureSession.stopRunning()
    }

    // MARK: Protocol AVCaptureMetadataOutputObjectsDelegate

    public func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        guard let metadataObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject else {
            logWarning(message: "Failed to get metadataObject from camera")
            return
        }

        if supportedCodeTypes.contains(metadataObject.type) {
            guard let stringValue = metadataObject.stringValue else {
                logWarning(message: "Failed to convert metadataObject to string format")
                return
            }

            codeHandler?(stringValue)
        }
    }

    // MARK: - Private Methods

    private func configureCaptureSession() {
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInDualCamera],
                                                                      mediaType: AVMediaType.video,
                                                                      position: .back)

        guard let captureDevice = deviceDiscoverySession.devices.first else {
            logWarning(message: "Failed to convert metadataObject to string format")
            return
        }

        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            captureSession.addInput(input)
        } catch {
            logWarning(message: "An error occurred during capture session: <\(error)>")
            return
        }

        let captureMetadataOutput = AVCaptureMetadataOutput()
        captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        captureMetadataOutput.metadataObjectTypes = supportedCodeTypes
        captureSession.addOutput(captureMetadataOutput)
    }

}
