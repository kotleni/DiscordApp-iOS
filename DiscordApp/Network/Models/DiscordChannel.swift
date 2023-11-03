//
//  Channel.swift
//  DiscordApp
//
//  Created by Viktor Varenik on 19.03.2023.
//

import Foundation

// ref: https://discord.com/developers/docs/resources/channel#channel-object
// types: https://discord.com/developers/docs/resources/channel#channel-object-channel-types
struct DiscordChannel: Codable {
    let id: String                              // unique ID
    let type: Int                               // type of channel
    let guildId: String?                        // ID of the guild (may be missing for some channels)
    let position: Int?                          // sorting position of the channel
    // let permission_overwrites: [Overwrite]   // explicit permission overwrites for members and roles
    let name: String?                           // name of the channel (1-100 characters)
    let topic: String?                          // channel topic (0-1024 characters for all others)
    let isNsfw: Bool?                           // whether the channel is nsfw
    let lastMessageId: String?                  // the id of the last message sent in this channel (or thread)
    // TODO: Add all properties
    
    enum CodingKeys: String, CodingKey {
        case id
        case type
        case guildId = "guild_id"
        case position
        // case permission_overwrites
        case name
        case topic
        case isNsfw = "nsfw"
        case lastMessageId = "last_message_id"
    }
}
