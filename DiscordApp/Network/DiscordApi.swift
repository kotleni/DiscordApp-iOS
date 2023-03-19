//
//  DiscordApi.swift
//  DiscordApp
//
//  Created by Victor Varenik on 19.03.2023.
//

import Foundation

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
    
    private func makeRequest(url: String, completion: @escaping (Data) -> Void) {
        guard let request = buildURLRequest(url: url) else { return }
        URLSession.shared.dataTask(with: request) { data, resp, err in
            if let err = err {
                print(err.localizedDescription)
                return
            }
            guard let data = data else { return }
            completion(data)
        }.resume()
    }
    
    /// Get guilds from account
    func getGuilds(completion: @escaping ([Guild]) -> Void) {
        makeRequest(url: "/users/@me/guilds") { data in
            let decoder = JSONDecoder()
            let guilds = try! decoder.decode([Guild].self, from: data)
            DispatchQueue.main.async {
                completion(guilds)
            }
        }
    }
    
    /// Get channels from guild
    func getChannels(guildId: String, completion: @escaping ([Channel]) -> Void) {
        makeRequest(url: "/guilds/\(guildId)/channels") { data in
            let decoder = JSONDecoder()
            let channels = try! decoder.decode([Channel].self, from: data)
            DispatchQueue.main.async {
                completion(channels)
            }
        }
    }
    
    /// Get messages from channel
    func getMessages(channelId: String, completion: @escaping ([Message]) -> Void) {
        makeRequest(url: "/channels/\(channelId)/messages") { data in
            let decoder = JSONDecoder()
            let messages = try! decoder.decode([Message].self, from: data)
            DispatchQueue.main.async {
                completion(messages)
            }
        }
    }
}
