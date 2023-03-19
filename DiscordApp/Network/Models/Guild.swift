//
//  Guild.swift
//  DiscordApp
//
//  Created by Victor Varenik on 19.03.2023.
//

import Foundation

class Guild: Decodable {
    let id: String
    let name: String
    let icon: String
    let owner: Bool
}
