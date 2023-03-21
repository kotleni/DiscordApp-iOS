//
//  URLResponse.swift
//  DiscordApp
//
//  Created by Victor Varenik on 21.03.2023.
//

import Foundation

extension URLResponse {
    func verify() -> NetworkingError? {
        guard let code, let url else {
            return .invalidRequest(url)
        }
        switch code {
        case 200...299:
            return nil
        default:
            let localizedString = HTTPURLResponse.localizedString(forStatusCode: code)
            let description = "\(url) - \(code) - \(localizedString)"
            return .badStatusCode(description, code: code)
        }
    }
    
    var code: Int? {
        if let http = self as? HTTPURLResponse {
            return http.statusCode
        } else {
            return nil
        }
    }
}
