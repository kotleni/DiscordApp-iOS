//
//  Channel.swift
//  DiscordApp
//
//  Created by Victor Varenik on 19.03.2023.
//

import Foundation

// ref: https://discord.com/developers/docs/resources/channel#channel-object
// types: https://discord.com/developers/docs/resources/channel#channel-object-channel-types
struct DiscordChannel: Codable {
    let id: String                              // unique ID
    let type: Int                               // type of channel
    let guild_id: String?                       // ID of the guild (may be missing for some channels)
    let position: Int?                          // sorting position of the channel
    // let permission_overwrites: [Overwrite]   // explicit permission overwrites for members and roles
    let name: String?                           // name of the channel (1-100 characters)
    let topic: String?                          // channel topic (0-1024 characters for all others)
    let nsfw: Bool?                             // whether the channel is nsfw
    let last_message_id: String?                // the id of the last message sent in this channel (or thread)
    // TODO: Add all properties
}
