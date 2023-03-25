//
//  MessageTableViewCell.swift
//  DiscordApp
//
//  Created by Вячеслав Макаров on 20.03.2023.
//

import UIKit

final class MessageTableViewCell: UITableViewCell {
    private var attachmentsHeightConstraint: NSLayoutConstraint?
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let timestampLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var avatarImageView: CachedImageView = {
        let avatarImageView = CachedImageView(type: .avatar)
        avatarImageView.backgroundColor = .white
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        return avatarImageView
    }()
    
    private lazy var attachmentsGrid: AttachmentsGrid = {
        let attachmentGrid = AttachmentsGrid()
        attachmentGrid.isHidden = true
//        attachmentGrid.backgroundColor = .yellow
        return attachmentGrid
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        transform = CGAffineTransform(rotationAngle: Double.pi)
        backgroundColor = .clear
        
        [avatarImageView, attachmentsGrid, nameLabel, messageLabel, timestampLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        setUpConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
//        contentImageView.image = nil
//        contentImageView.isHidden = true
        attachmentsGrid.isHidden = true
        attachmentsGrid.clearAttachments()
    }
    
    private func setUpConstraints() {
        let padding = 8.0
        let avatarWidth = 35.0
        let maximumGridHeight = 400.0
        attachmentsHeightConstraint = attachmentsGrid.heightAnchor.constraint(lessThanOrEqualToConstant: maximumGridHeight)
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            avatarImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            avatarImageView.widthAnchor.constraint(equalToConstant: avatarWidth),
            avatarImageView.heightAnchor.constraint(equalTo: avatarImageView.widthAnchor),
            avatarImageView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -padding),
            
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: padding),
            nameLabel.trailingAnchor.constraint(equalTo: timestampLabel.leadingAnchor, constant: -padding),
            nameLabel.bottomAnchor.constraint(equalTo: messageLabel.topAnchor, constant: -padding),
            
            timestampLabel.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor),
            timestampLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            
            messageLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: padding),
            messageLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: padding),
            messageLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            messageLabel.bottomAnchor.constraint(lessThanOrEqualTo: attachmentsGrid.topAnchor, constant: -padding),
            
            attachmentsGrid.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: padding),
            attachmentsGrid.trailingAnchor.constraint(equalTo: timestampLabel.trailingAnchor, constant: -padding),
//            attachmentsGrid.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: padding),
//            attachmentsGrid.heightAnchor.constraint(lessThanOrEqualToConstant: maximumGridHeight),
            attachmentsHeightConstraint!,
            attachmentsGrid.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding)
        ])
    }
    
    private func setImage(by user: DiscordUser?) {
        guard let user = user else { return }
        avatarImageView.bindData(name: user.username, url: user.getAvatarUrl())
    }
    
    private func getDate(_ isoDate: String) -> String {
        let isoDateFormatter = ISO8601DateFormatter()
        isoDateFormatter.formatOptions = [
            .withFullDate,
            .withFullTime,
            .withDashSeparatorInDate,
            .withFractionalSeconds
        ]
        guard let date = isoDateFormatter.date(from: isoDate) else { return "nil" }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm dd.MM.yyyy"
        return dateFormatter.string(from: date)
    }
    
    private func loadAttachments(_ attachments: [DiscordAttachment]) {
        
        attachmentsGrid.isHidden = false
        attachmentsGrid.setAttachments(attachments)
        if attachments.count > 1 {
            attachmentsHeightConstraint?.constant = CGFloat(50 * attachmentsGrid.attachmentsCount)
        } else {
            attachmentsHeightConstraint?.constant = CGFloat(200)
        }
    }
    
    func setMessage(_ message: DiscordMessage) {
        nameLabel.text = message.author.username
        messageLabel.text = message.content
        timestampLabel.text = getDate(message.timestamp)
        setImage(by: message.author)
        
        if !message.attachments.isEmpty {
            loadAttachments(message.attachments)
        }
    }
}
