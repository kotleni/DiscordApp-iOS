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
    
    private lazy var avatarImageView: RoundedImageView = {
        let avatarImageView = RoundedImageView()
        avatarImageView.backgroundColor = .green
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
        guard var day = components.day, var month = components.month, let year = components.year, var hour = components.hour, var minute = components.minute else { return "error" }
        let dayString: String = (day < 10) ? "0\(day)" : String(day)
        let monthString: String = (month < 10) ? "0\(month)" : String(month)
        let hourString: String = (hour < 10) ? "0\(hour)" : String(hour)
        let minuteString: String = (minute < 10) ? "0\(minute)" : String(minute)
        return "\(dayString).\(monthString).\(year) \(hourString):\(minuteString)"
    }
    
    private func setGUISettings() {
        contentView.addSubview(avatarImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(messageLabel)
        contentView.addSubview(timestampLabel)
    }
    
    private func setupConstraints() {
        let padding = 10.0
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            avatarImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            avatarImageView.widthAnchor.constraint(equalToConstant: 75.0),
            avatarImageView.heightAnchor.constraint(equalTo: avatarImageView.widthAnchor),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: padding),
            nameLabel.trailingAnchor.constraint(equalTo: timestampLabel.leadingAnchor, constant: -padding),
            timestampLabel.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor),
            timestampLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            messageLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: padding),
            messageLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: padding),
            messageLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            messageLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -padding)
        ])
        
    }
}
