//
//  Guild.swift
//  DiscordApp
//
//  Created by Victor Varenik on 19.03.2023.
//

import Foundation

// ref: https://discord.com/developers/docs/resources/guild#guild-object
struct DiscordGuild: Decodable {
    let id: String                  // unique ID
    let name: String                // guild name (2-100 characters, excluding trailing and leading whitespace)
    let icon: String?               // icon hash
    let icon_hash: String?          // icon hash (returned when in the template object)
    let splash: String?             // splash hash
    let discovery_splash: String?   // discovery splash hash; only present for guilds with the "DISCOVERABLE" feature
    let owner: Bool?                // true if the user is the owner of the guild
    let owner_id: String?           // ID of owner
    let permissions: String?        // total permissions for the user in the guild (excludes overwrites)
    let afk_channel_id: String?     // id of afk channel
    // TODO: Add all properties
    
    func getIconUrl() -> String? {
        guard let icon = icon else { return nil }
        return "https://cdn.discordapp.com/icons/\(id)/\(icon).png"
    }
}
