//
//  Attachment.swift
//  DiscordApp
//
//  Created by Victor Varenik on 20.03.2023.
//

import Foundation

// ref: https://discord.com/developers/docs/resources/channel#attachment-object
struct DiscordAttachment: Codable {
    let id: String              // unique ID
    let filename: String        // name of file attached
    let description: String?    // description for the file (max 1024 characters)
    let contentType: String?   // media type (mime)
    let size: Int               // size of file in bytes
    let url: String             // source url of file
    let proxyURL: String       // a proxied url of file
    let width: Int?             // width of file (if image)
    let height: Int?            // height of file (if image)
    let isEphemeral: Bool?        // whether this attachment is ephemeral
    
    enum CodingKeys: String, CodingKey {
        case id
        case filename
        case description
        case contentType = "content_type"
        case size
        case url
        case proxyURL = "proxy_url"
        case width
        case height
        case isEphemeral = "ephemeral"
    }
}
