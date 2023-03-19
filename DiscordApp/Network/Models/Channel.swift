//
//  Channel.swift
//  DiscordApp
//
//  Created by Victor Varenik on 19.03.2023.
//

import Foundation

class Channel: Decodable {
    let id: String
    let type: Int
    let name: String
    let position: Int
}
