//
//  Message.swift
//  DiscordApp
//
//  Created by Victor Varenik on 19.03.2023.
//

import Foundation

// ref: https://discord.com/developers/docs/resources/channel#message-object
// types: https://discord.com/developers/docs/resources/channel#message-object-message-types
class Message: Decodable, Equatable {
    let id: String                              // ID, unique for channel
    let channel_id: String                      // ID of channel
    let author: User                            // author of this message (not guaranteed a valid user, see below)
    let content: String                         // contents of the message
    let timestamp: String                       // when this message was sent (ISO8601)
    let edited_timestamp: String?               // when this message was edited (ISO8601) (or null if never)
    let tts: Bool                               // whether this was a TTS message
    let mention_everyone: Bool                  // whether this message mentions everyone
    let mentions: [User]                        // users specifically mentioned in the message
    // let mention_roles: [Role]                // roles specifically mentioned in this message
    // let mention_channels: [ChannelMention]   // channels specifically mentioned in this message
    let attachments: [Attachment]               // any attached files
    // let embeds: [Embed]                      // any embedded content
    // let reactions: [Reaction]                // reactions to the message
    let nonce: String?                          // used for validating a message was sent (need be random)
    let pinned: Bool                            // whether this message is pinned
    let webhook_id: String?                     // webhook ID (only is generated by webhook)
    let type: Int                               // type of message
    // let activity: MessageActivity?           // sent with Rich Presence-related chat embeds
    // let application: Application?            // sent with Rich Presence-related chat embeds
    let application_id: String?                 // user application ID (only is interaction or in-app wehbook)
    // let message_reference: MessageReference? // data showing the source of a crosspost, channel follow add, pin, or reply message
    let flags: Int?                             // message flags combined as a bitfield
    // let referenced_message: Message?         // message associated with the message_reference
    // let interaction: MessageInteraction?     // sent if the message is a response to an Interaction
    let thread: Channel?                        // thread that was started from this message
    // let components: [TODO]                   // components, like buttons/actions/other
    // let sticker_items: [MessageStickerItem]? // message contains stickers
    let position: Int?                          // message position in thread
    // let role_subscription_data: RoleSubscriptionData // see ref

    static func == (lhs: Message, rhs: Message) -> Bool {
        lhs.id == rhs.id
    }
}
