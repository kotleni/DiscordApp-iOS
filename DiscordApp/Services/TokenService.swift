//
//  TokenService.swift
//  DiscordApp
//
//  Created by Victor Varenik on 21.03.2023.
//

import Foundation

class TokenService {
    @KeychainStorage(key: "accessTokenKeychainKesy", defaultValue: nil)
    static var userToken: String?
    
    static var isValidToken: Bool { userToken != .none }
}
