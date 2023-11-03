//
//  Guild.swift
//  DiscordApp
//
//  Created by Viktor Varenik on 19.03.2023.
//

import Foundation

// ref: https://discord.com/developers/docs/resources/guild#guild-object
struct DiscordGuild: Codable {
    let id: String                  // unique ID
    let name: String                // guild name (2-100 characters, excluding trailing and leading whitespace)
    let icon: String?               // icon hash
    let iconHash: String?           // icon hash (returned when in the template object)
    let splash: String?             // splash hash
    let discoverySplash: String?    // discovery splash hash; only present for guilds with the "DISCOVERABLE" feature
    let isOwner: Bool?                // true if the user is the owner of the guild
    let ownerId: String?            // ID of owner
    let permissions: String?        // total permissions for the user in the guild (excludes overwrites)
    let afkChannelId: String?       // id of afk channel
    // TODO: Add all properties
    
    func getIconUrl() -> String? {
        guard let icon = icon else { return nil }
        return "https://cdn.discordapp.com/icons/\(id)/\(icon).png"
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case icon
        case iconHash = "icon_hash"
        case splash
        case discoverySplash = "discovery_splash"
        case isOwner = "owner"
        case ownerId = "owner_id"
        case permissions
        case afkChannelId = "afk_channel_id"
    }
}
