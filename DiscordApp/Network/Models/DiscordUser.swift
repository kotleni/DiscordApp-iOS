//
//  Author.swift
//  DiscordApp
//
//  Created by Victor Varenik on 19.03.2023.
//

import Foundation

// ref: https://discord.com/developers/docs/resources/user#user-object
struct DiscordUser: Codable {
    let id: String            // unique ID
    let username: String      // username, not unique
    let discriminator: String // 4-digit discord-tag
    let avatar: String?       // avatar hash
    let isBot: Bool?            // whether the user belongs to an OAuth2 application
    let isSystem: Bool?         // whether the user is an Official Discord System user (part of the urgent message system)
    let isMfaEnabled: Bool?    // whether the user has two factor enabled on their account
    let banner: String?       // banner hash
    let accentColor: Int?    // banner color as an integer representation of hexadecimal color code
    let locale: String?       // chosen language option
    let verified: Bool?       // true if account email verified
    let email: String?        // email
    let flags: Int?           // flags on a user's account
    let premiumType: Int?    // type of Nitro subscription
    let publicFlags: Int?    // public flags on a user's account
    
    func getAvatarUrl() -> String? {
        guard let avatar = avatar else { return nil }
        return "https://cdn.discordapp.com/avatars/\(id)/\(avatar)"
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case username
        case discriminator
        case avatar
        case isBot = "bot"
        case isSystem = "system"
        case isMfaEnabled = "mfa_enabled"
        case banner
        case accentColor = "accent_color"
        case locale
        case verified
        case email
        case flags
        case premiumType = "premium_type"
        case publicFlags = "public_flags"
    }
}
