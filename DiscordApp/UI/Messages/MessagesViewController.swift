//
//  MessagesViewController.swift
//  DiscordApp
//
//  Created by Вячеслав Макаров on 20.03.2023.
//

import UIKit


// MARK: UIViewController
final class MessagesViewController: UITableViewController {
    var channel: Channel?
    let rotationAngle = 3.14159265359
    
    private var messages = Array<Message>() {
        didSet {
            tableView.reloadData()
        }
    }
    
    convenience init(channel: Channel) {
        self.init()
        self.channel = channel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        configureTableView()
    }
   
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startWatchdog()
    }
    
    private func startWatchdog() {
        Timer.scheduledTimer(timeInterval: 0.50, target: self, selector: #selector(updateChat), userInfo: nil, repeats: true)
    }
    
    @objc private func updateChat() {
        getMessages()
    }
    
    private func getMessages() {
        guard let channelId = channel?.id else { return }
        DiscordApi.shared.getMessages(channelId: channelId) { result in
            switch result {
            case .success(let messages):
                if messages.last != self.messages.last {
                    self.messages = messages
//                    self.tableView.scrollToRow(at: IndexPath(row: .zero, section: .zero), at: .bottom, animated: true)
                }
            case .failure(let err):
                err.presetErrorAlert(viewController: self)
            }
        }
    }
    
    private func configureVC() {
        title = channel?.name ?? "Text channel"
    }
    
    private func configureTableView() {
        let padding = 10.0
        tableView.register(MessageTableViewCell.self, forCellReuseIdentifier: MessageTableViewCell.nameOfClass)
        tableView.contentInset.bottom = self.statusBarHeight + padding
        tableView.estimatedRowHeight = 300.0
        tableView.rowHeight = UITableView.automaticDimension
        tableView.transform = CGAffineTransform(rotationAngle: rotationAngle)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        messages.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MessageTableViewCell.nameOfClass, for: indexPath) as? MessageTableViewCell else { return UITableViewCell() }
        cell.transform = CGAffineTransform(rotationAngle: rotationAngle)
        cell.setMessage(messages[indexPath.row])
        return cell
    }
    
   
}
