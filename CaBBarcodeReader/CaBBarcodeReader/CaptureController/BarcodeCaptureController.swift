import AVFoundation

// MARK: - Protocol

public protocol BarcodeCaptureController: AnyObject {
    func start()
    func stop()
}

// MARK: - Implementation

public final class BarcodeCaptureControllerImpl: NSObject, BarcodeCaptureController, AVCaptureMetadataOutputObjectsDelegate {

    // MARK: - Public Types

    public typealias BarcodeObjectType = AVMetadataObject.ObjectType
    public typealias CodeHandler = ((String) -> Void)

    // MARK: - Private Properties

    private let captureSession: AVCaptureSession
    private let supportedCodeTypes: [BarcodeObjectType]
    private var codeHandler: CodeHandler?

    // MARK: - Init & Deinit

    public init(captureSession: AVCaptureSession, supportedCodeTypes: [BarcodeObjectType], codeHandler: CodeHandler? = nil) {
        self.captureSession = captureSession
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
            // TODO: Add logs
            return
        }

        if supportedCodeTypes.contains(metadataObject.type) {
            guard let stringValue = metadataObject.stringValue else {
                // TODO: Add logs
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
            // TODO: Add logs
            return
        }

        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            captureSession.addInput(input)
        } catch {
            // TODO: Add logs
            return
        }

        let captureMetadataOutput = AVCaptureMetadataOutput()
        captureSession.addOutput(captureMetadataOutput)
    }

}
