//
//  DiscordApi.swift
//  DiscordApp
//
//  Created by Victor Varenik on 19.03.2023.
//

import Foundation
import OSLog

final class DiscordClient {
    private static let baseURL = "https://discord.com/api/v9"
    private static let token = TokenService.userToken
    
    
    private static func buildUrl(url: String) -> URL? {
        return URL(string: "\(baseURL)/\(url)")
    }
    
    private static func buildURLRequest(url: String, method: String = "GET") -> URLRequest? {
        guard let url = buildUrl(url: url) else { return nil }
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue(token, forHTTPHeaderField: "Authorization")
        request.httpMethod = method
        return request
    }
    
    private static func parseResponse<T: Codable>(data: Data?, response: URLResponse?, error: Error?) -> Result<T, NetworkingError>? {
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
    
    private static func makeRequest<T: Codable>(url: String, completion: @escaping (Result<T, NetworkingError>) -> Void) {
        guard let request = buildURLRequest(url: url) else { return }
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let result: Result<T, NetworkingError> = self.parseResponse(data: data, response: response, error: error)
                else { return }
            DispatchQueue.main.async { completion(result) }
        }.resume()
    }
    
    private static func makePostRequest(url: String, text: String, completion: @escaping ()->())  {
        guard var request = buildURLRequest(url: url, method: "POST") else { return }
        let json: [String: Any] = ["content": text,
                                   "tts": false,
                                   ]
        guard let jsonData = try? JSONSerialization.data(withJSONObject: json) else { return }
        request.httpBody = jsonData
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                completion()
            }
            
        }.resume()
    }
    
    /// Get guilds from account
    static func getGuilds(completion: @escaping (Result<[DiscordGuild], NetworkingError>) -> Void) -> Void {
        makeRequest(url: "/users/@me/guilds", completion: completion)
    }
    
    /// Get channels from guild
    static func getChannels(guildId: String, completion: @escaping (Result<[DiscordChannel], NetworkingError>) -> Void) {
        makeRequest(url: "/guilds/\(guildId)/channels", completion: completion)
    }
    
    /// Get messages from channel
    static func getMessages(channelId: String, completion: @escaping (Result<[DiscordMessage], NetworkingError>) -> Void) {
        makeRequest(url: "/channels/\(channelId)/messages", completion: completion)
    }
    
    ///Sends message
    static func sendMessage(channelId: String, text: String, completion: @escaping ()->())  {
        makePostRequest(url: "/channels/\(channelId)/messages", text: text, completion: completion)
    }
}
