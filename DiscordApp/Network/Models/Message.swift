//
//  Message.swift
//  DiscordApp
//
//  Created by Victor Varenik on 19.03.2023.
//

import Foundation

class Message: Decodable, Equatable {
    static func == (lhs: Message, rhs: Message) -> Bool {
        lhs.id == rhs.id
    }
    
    let id: String
    let type: Int
    let content: String
    let channel_id: String
    let timestamp: String
    let author: Author
}
