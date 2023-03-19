//
//  Message.swift
//  DiscordApp
//
//  Created by Victor Varenik on 19.03.2023.
//

import Foundation

class Message: Decodable {
    let id: String
    let type: Int
    let content: String
    let channel_id: String
    let author: Author
}
