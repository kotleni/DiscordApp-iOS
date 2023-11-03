//
//  Logger.swift
//  DiscordApp
//
//  Created by Viktor Varenik on 20.03.2023.
//

import Foundation
import os.log

enum Logger {
    static private let osLog = OSLog(subsystem: Bundle.main.bundleIdentifier ?? "NO_BUNDLE", category: "Logger")
    
    static private func log(logLevel: OSLogType, message: String) {
        os_log("%{public}@", log: osLog, type: logLevel, message)
    }
    
    static func logInfo(message: String) {
        Logger.log(logLevel: .info, message: message)
    }

    static func logError(error: Error) {
        Logger.log(logLevel: .error, message: error.localizedDescription)
    }
}
