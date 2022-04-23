
final class FileWriter {

    enum DataType {
        case log
    }

    var destinationUrl: URL

    private let fileManager: FileManager = .default

    init(destinatioonURL: URL) {
        self.destinationUrl = destinatioonURL
    }

    func writeData(_ data: Any, of type: DataType) throws {
        switch type {
            case .log:
                guard let path = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
                    return
                }

                guard let stringData = data as? String else {
                    return
                }

                let filename = path.appendingPathComponent("health-spot.logs")
                try stringData.write(to: filename, atomically: true, encoding: String.Encoding.utf8)

        }
    }

}
