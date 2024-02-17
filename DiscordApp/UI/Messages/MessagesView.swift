//
//  Messagesswift
//  DiscordApp
//
//  Created by Viktor Varenik on 17.02.2024.
//

import UIKit

final class MessagesView: UIView {
    let tableView: UITableView = {
        let padding = 10.0
        let view = UITableView(frame: .zero, style: .plain)
        view.register(MessageTableViewCell.self, forCellReuseIdentifier: MessageTableViewCell.nameOfClass)
        // contentInset.bottom = self.statusBarHeight + padding
        view.estimatedRowHeight = 300.0
        // view.rowHeight = UITableautomaticDimension
        view.transform = CGAffineTransform(rotationAngle: Double.pi)
        return view
    }()
    
    let messageTextField: MessageFiledView = {
        let textField = MessageFiledView(frame: .zero)
        textField.placeholder = Text.hintEntermsg
        return textField
    }()
    
    let messageSendButton: CircularButton = {
        let button = CircularButton(type: .system)
        button.backgroundColor = Assets.Colors.buttonColor.color
        button.tintColor = .white
        button.setImage(UIImage(systemName: "arrow.up"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = Assets.Colors.plane.color
        tableView.backgroundColor = .clear
    
        [tableView, messageTextField, messageSendButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
        
        let messageTFHeigh = 35.0
        let padding = 10.0
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: messageTextField.topAnchor, constant: -8.0),
            tableView.leftAnchor.constraint(equalTo: leftAnchor),
            tableView.rightAnchor.constraint(equalTo: rightAnchor),
            
            messageTextField.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            messageTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            messageTextField.trailingAnchor.constraint(equalTo: messageSendButton.leadingAnchor, constant: -padding),
            messageTextField.heightAnchor.constraint(equalToConstant: messageTFHeigh),
            
            messageSendButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            messageSendButton.heightAnchor.constraint(equalTo: messageTextField.heightAnchor),
            messageSendButton.centerYAnchor.constraint(equalTo: messageTextField.centerYAnchor),
            messageSendButton.widthAnchor.constraint(equalTo: messageSendButton.heightAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
