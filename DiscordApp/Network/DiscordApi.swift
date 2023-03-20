//
//  DiscordApi.swift
//  DiscordApp
//
//  Created by Victor Varenik on 19.03.2023.
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
            return "Неправильно сформирован url: \(string)"
        case .invalidRequest(let url):
            return "Неправильно сформирован запрос: " + String(describing: url)
        case .parseError(let data, _):
#if DEBUG
            writeParserBreakingData(data)
#endif
            return "Ошибка парсинга"
        case .badStatusCode(let description, _):
            return "Неуспешный статус код HTTP: \(description)."
        case .emptyConfiguration:
            return "Необходимо задать конфигурацию (см. readme)"
        case .emptyResponse:
            return "Пустой ответ от сервера"
        case .emptyDataResponse:
            return "Отсутствуют данные для парсинга"
            //        case .wrongAppCredentials(let credentials):
            //            return "Не удалось распарсить данные пользователя \(credentials)"
        case .other(let error):
            return error.localizedDescription
        }
    }
    
    func writeParserBreakingData(_ data: Data) {
        guard let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            Logger.logInfo(message: "Данные неудачного парсинга: " + String(decoding: data, as: UTF8.self))
            return
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy_HH.mm.ssZ"
        let fileName = ["DecodingFailure", dateFormatter.string(from: Date())].joined(separator: "_")
        let file = path.appendingPathComponent(fileName, isDirectory: false).appendingPathExtension("txt")
        try? data.write(to: file)
        Logger.logInfo(message: "Данные на которых упал парсер записаны в \(file.path)")
    }
}

final class DiscordApi {
    static let shared = DiscordApi()
    
    private let baseURL = "https://discord.com/api/v9"
    private let token = "NDIwMTQ5ODY5NjAxMzU3ODI0.GcWC5s.8nEQeCww4xmCHXF-bX19Soq94p0Kyc4yNZuX9Y"
    
    private func buildUrl(url: String) -> URL? {
        return URL(string: "\(baseURL)/\(url)")
    }
    
    private func buildURLRequest(url: String) -> URLRequest? {
        guard let url = buildUrl(url: url) else { return nil }
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue(token, forHTTPHeaderField: "Authorization")
        return request
    }
    
    private func parseResponse<T: Decodable>(data: Data?, response: URLResponse?, error: Error?) -> Result<T, NetworkingError>? {
        // Общие ошибки
        if let error = error, let urlError = error as? URLError {
            if urlError.code == URLError.cancelled {
                return nil
            } else {
                let error = NetworkingError.other(error)
                Logger.logError(error: error)
                return .failure(error)
            }
        }
        guard let response, let code = response.code else {
            let error = NetworkingError.emptyResponse
            Logger.logError(error: error)
            return .failure(error)
        }
        // Проверка статус кода
        if let responseError = response.verify() {
            Logger.logError(error: responseError)
            return .failure(responseError)
        }
        // Парсинг данных
        guard let data = data else {
            let error = NetworkingError.emptyDataResponse(code: code)
            Logger.logError(error: error)
            return .failure(error)
        }
        
        let decoder = JSONDecoder()
        do {
            let data = try decoder.decode(T.self, from: data)
            return .success(data)
        } catch {
            let error = NetworkingError.parseError(data, code: code)
            Logger.logError(error: error)
            return .failure(.other(error))
        }
    }
    
    private func makeRequest<T: Decodable>(url: String, completion: @escaping (Result<T, NetworkingError>) -> Void) {
        guard let request = buildURLRequest(url: url) else { return }
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let result: Result<T, NetworkingError> = self.parseResponse(data: data, response: response, error: error)
                else { return }
            DispatchQueue.main.async { completion(result) }
        }.resume()
    }
    
    /// Get guilds from account
    func getGuilds(completion: @escaping (Result<[Guild], NetworkingError>) -> Void) -> Void {
        makeRequest(url: "/users/@me/guilds", completion: completion)
    }
    
    /// Get channels from guild
    func getChannels(guildId: String, completion: @escaping (Result<[Channel], NetworkingError>) -> Void) {
        makeRequest(url: "/guilds/\(guildId)/channels", completion: completion)
    }
    
    /// Get messages from channel
    func getMessages(channelId: String, completion: @escaping (Result<[Message], NetworkingError>) -> Void) {
        makeRequest(url: "/channels/\(channelId)/messages", completion: completion)
    }
}
