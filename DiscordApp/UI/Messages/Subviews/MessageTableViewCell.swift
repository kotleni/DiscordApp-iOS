//
//  MessageTableViewCell.swift
//  DiscordApp
//
//  Created by Вячеслав Макаров on 20.03.2023.
//

import UIKit

final class MessageTableViewCell: UITableViewCell {
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.text = "Message..."
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let timestampLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Arial", size: 12)
        label.text = "Time"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var avatarImageView: AvatarImageView = {
        let avatarImageView = AvatarImageView()
        avatarImageView.backgroundColor = .white
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        return avatarImageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setGUISettings()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
//        messageLabel.text = .none
//        timestampLabel.text = .none
    }
    
    func setMessage(_ message: Message) {
        nameLabel.text = message.author.username
        messageLabel.text = message.content
        timestampLabel.text = getDate(message.timestamp)
        setImage(by: message.author.getAvatarUrl())
    }
    
    private func getDate(_ isoDate: String) -> String {
        let isoDateFormatter = ISO8601DateFormatter()
        isoDateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        isoDateFormatter.formatOptions = [
            .withFullDate,
            .withFullTime,
            .withDashSeparatorInDate,
            .withFractionalSeconds]
        guard let realDate = isoDateFormatter.date(from: isoDate) else { return "error" }
        let calendar = NSCalendar.current
        let components = calendar.dateComponents([.day, .month, .year, .hour, .minute], from: realDate)
        guard let day = components.day, let month = components.month, let year = components.year, let hour = components.hour, let minute = components.minute else { return "error" }
        let dayString: String = (day < 10) ? "0\(day)" : String(day)
        let monthString: String = (month < 10) ? "0\(month)" : String(month)
        let hourString: String = (hour < 10) ? "0\(hour)" : String(hour)
        let minuteString: String = (minute < 10) ? "0\(minute)" : String(minute)
        return "\(dayString).\(monthString).\(year) \(hourString):\(minuteString)"
    }
    
    private func setImage(by url: String?) {
        // TODO: do normal single char avatar generator
        let defaultAvatartLink = "https://cdn3.iconfinder.com/data/icons/popular-services-brands-vol-2/512/discord-512.png"
        
        if let url = url {
            avatarImageView.loadImage(url)
        } else {
            avatarImageView.loadImage(defaultAvatartLink)
        }
    }
    
    private func setGUISettings() {
        contentView.addSubview(avatarImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(messageLabel)
        contentView.addSubview(timestampLabel)
    }
    
    private func setupConstraints() {
        let padding = 10.0
        let avatarWidth = 50.0
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
            messageLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -padding)
        ])
        
    }
}
