//
//  MessagesViewController.swift
//  DiscordApp
//
//  Created by Вячеслав Макаров on 20.03.2023.
//

import UIKit

// MARK: UIViewController
final class MessagesViewController: UIViewController {
    private lazy var tableView: UITableView = {
        let padding = 10.0
        let view = UITableView(frame: .zero, style: .plain)
        view.register(MessageTableViewCell.self, forCellReuseIdentifier: MessageTableViewCell.nameOfClass)
        view.contentInset.bottom = self.statusBarHeight + padding
        view.estimatedRowHeight = 300.0
        view.rowHeight = UITableView.automaticDimension
        view.transform = CGAffineTransform(rotationAngle: rotationAngle)
        view.delegate = self
        view.dataSource = self
        return view
    }()
    
    private let messageTextField: MessageFiledView = {
        let textField = MessageFiledView(frame: .zero)
        textField.placeholder = "Message"
        return textField
    }()
    
    private lazy var messageSendButton: CircularButton = {
        let button = CircularButton(type: .system)
        button.backgroundColor = Assets.Colors.buttonColor.color
        button.tintColor = .white
        button.setImage(UIImage(systemName: "arrow.up"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(sendMessage(sender:)), for: .touchUpInside)
        return button
    }()
    
    private var channel: DiscordChannel?
    private let rotationAngle = Double.pi     // 180˚ in radians
    private let watchdogTimerDelay = 1.5      // in secs
    
    private var messages: [DiscordMessage] = []
    
    convenience init(channel: DiscordChannel) {
        self.init()
        self.channel = channel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        view.backgroundColor = Assets.Colors.plane.color
        tableView.backgroundColor = .clear
        title = channel?.name ?? "Text channel"
        edgesForExtendedLayout = .all
        
        [tableView, messageTextField, messageSendButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        setUpConstraints()
    }
   
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startWatchdog()
    }
    
    @objc
    private func sendMessage(sender: CircularButton) {
        DiscordClient.sendMessage(channelId: channel!.id, text: messageTextField.text ?? "") { [self] in
            messageTextField.text = ""
        }
    }
    
    @objc
    private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.view.frame.origin.y -= keyboardSize.height
        }
    }

    @objc
    private func keyboardWillHide(notification: NSNotification) {
        self.view.frame.origin.y = 0
    }
    
    @objc
    private func updateChat() {
        fetchMessages()
    }
    
    private func setUpConstraints() {
        let messageTFHeigh = 35.0
        let padding = 10.0
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: messageTextField.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            
            messageTextField.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            messageTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            messageTextField.trailingAnchor.constraint(equalTo: messageSendButton.leadingAnchor, constant: -padding),
            messageTextField.heightAnchor.constraint(equalToConstant: messageTFHeigh),
            
            messageSendButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            messageSendButton.heightAnchor.constraint(equalTo: messageTextField.heightAnchor),
            messageSendButton.centerYAnchor.constraint(equalTo: messageTextField.centerYAnchor),
            messageSendButton.widthAnchor.constraint(equalTo: messageSendButton.heightAnchor)
        ])
    }
    
    private func startWatchdog() {
        Timer.scheduledTimer(timeInterval: watchdogTimerDelay, target: self, selector: #selector(updateChat), userInfo: nil, repeats: true)
    }
    
    private func fetchMessages() {
        guard let channelId = channel?.id else { return }
        DiscordClient.getMessages(channelId: channelId) { result in
            switch result {
            case .success(let messages):
                if messages.last != self.messages.last {
                    self.messages = messages
                    self.tableView.reloadData()
//                    self.tableView.scrollToRow(at: IndexPath(row: .zero, section: .zero), at: .bottom, animated: true)
                }
            case .failure(let err):
                err.presetErrorAlert(viewController: self)
            }
        }
    }
}

// MARK: UITableViewDataSource
extension MessagesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MessageTableViewCell.nameOfClass, for: indexPath) as? MessageTableViewCell else { return UITableViewCell() }
        cell.setMessage(messages[indexPath.row])
        return cell
    }
}

// MARK: UITableViewDelegate
extension MessagesViewController: UITableViewDelegate {
    
}
