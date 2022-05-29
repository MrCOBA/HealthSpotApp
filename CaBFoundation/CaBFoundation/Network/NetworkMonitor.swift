import Network

// MARK: - Protocol

public protocol NetworkMonitor: AnyObject {

    var isReachable: Bool { get }
    var isReachableOnCellular: Bool { get }

    func startMonitoring()
    func stopMonitoring()

}

// MARK: - Implementation

public final class NetworkMonitorImpl: NetworkMonitor {

    // MARK: - Public Properties

    public var isReachable: Bool { status == .satisfied }
    public var isReachableOnCellular: Bool = true

    // MARK: - Private Properties

    private let monitor: NWPathMonitor
    private var status: NWPath.Status

    // MARK: - Init

    public init() {
        monitor = NWPathMonitor()
        status = .requiresConnection
    }

    // MARK: - Public Methods

    public func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            self?.status = path.status
            self?.isReachableOnCellular = path.isExpensive

            if path.status == .satisfied {
                logInfo(message: "Network connected successfully!")
            } else {
                logInfo(message: "Lost internet connection")
            }
        }

        let queue = DispatchQueue(label: "HealthSpotNetworkMonitor")
        monitor.start(queue: queue)
    }

    public func stopMonitoring() {
        monitor.cancel()
    }

}
