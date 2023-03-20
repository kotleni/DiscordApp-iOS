//
//  Author.swift
//  DiscordApp
//
//  Created by Victor Varenik on 19.03.2023.
//

import Foundation

// ref: https://discord.com/developers/docs/resources/user#user-object
struct User: Decodable { // TODO: Rename to User
    let id: String            // unique ID
    let username: String      // username, not unique
    let discriminator: String // 4-digit discord-tag
    let avatar: String?       // avatar hash
    let bot: Bool?            // whether the user belongs to an OAuth2 application
    let system: Bool?         // whether the user is an Official Discord System user (part of the urgent message system)
    let mfa_enabled: Bool?    // whether the user has two factor enabled on their account
    let banner: String?       // banner hash
    let accent_color: Int?    // banner color as an integer representation of hexadecimal color code
    let locale: String?       // chosen language option
    let verified: Bool?       // true if account email verifed
    let email: String?        // email
    let flags: Int?           // flags on a user's account
    let premium_type: Int?    // type of Nitro subscription
    let public_flags: Int?    // public flags on a user's account
}
