//
//  NetworkingError.swift
//  DiscordApp
//
//  Created by Victor Varenik on 21.03.2023.
//

import Foundation
import OSLog

enum NetworkingError {
    case emptyConfiguration, emptyResponse
    //case wrongAppCredentials(_ credentials: AppCredentials)
    case invalidRequest(_ url: URL?)
    case invalidURL(_ string: String)
    case emptyDataResponse(code: Int)
    case parseError(_ data: Data, code: Int)
    case badStatusCode(_ info: String, code: Int)
    case other(_ error: Error)
}

extension NetworkingError: LocalizedError {
    public var statusCode: Int? {
        switch self {
        case .emptyConfiguration, .emptyResponse, .invalidURL, .invalidRequest, .other:
            return nil
        case .emptyDataResponse(code: let code), .parseError(_, code: let code), .badStatusCode(_, code: let code):
            return code
        }
    }
    
    public var errorDescription: String? {
        switch self {
        case .invalidURL(let string):
            return "Invalid url: \(string)"
        case .invalidRequest(let url):
            return "Invalid request: " + String(describing: url)
        case .parseError(let data, _):
#if DEBUG
            writeParserBreakingData(data)
#endif
            return "Model parse error"
        case .badStatusCode(let description, _):
            return "Bad status code HTTP: \(description)."
        case .emptyConfiguration:
            return "Empty configuration"
        case .emptyResponse:
            return "Empty response from server"
        case .emptyDataResponse:
            return "Response data is empty"
            //        case .wrongAppCredentials(let credentials):
            //            return "Не удалось распарсить данные пользователя \(credentials)"
        case .other(let error):
            return error.localizedDescription
        }
    }
    
    func writeParserBreakingData(_ data: Data) {
        guard let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            Logger.logInfo(message: "Breaking data from parsing error: " + String(decoding: data, as: UTF8.self))
            return
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy_HH.mm.ssZ"
        let fileName = ["DecodingFailure", dateFormatter.string(from: Date())].joined(separator: "_")
        let file = path.appendingPathComponent(fileName, isDirectory: false).appendingPathExtension("txt")
        try? data.write(to: file)
        Logger.logInfo(message: "Json dump has ben writed to \(file.path)")
    }
}
