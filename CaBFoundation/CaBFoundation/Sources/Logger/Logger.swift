import OSLog

// MARK: - System Logger Instance

private let logger = Logger()

// MARK: - Default Log

public func log(message: String) {
    logger.log("\(message)")
}

// MARK: - Info Log

public func logInfo(message: String) {
    logger.info("<INFO> \(message)")
}

// MARK: - Warning Log

public func logWarning(message: String) {
    logger.warning("<WARNING> \(message)")
}

// MARK: - Error Log

public func logError(message: String) {
    logger.error("<ERROR> \(message)")
    assertionFailure(message)
}
