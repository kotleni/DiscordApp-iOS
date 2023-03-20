//
//  MessagesViewController.swift
//  DiscordApp
//
//  Created by Вячеслав Макаров on 20.03.2023.
//

import UIKit


// MARK: UIViewController
final class MessagesViewController: UITableViewController {
    
    private var messages = Array<Message>() {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }
   
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getMessages()
    }
    
    private func getMessages() {
        DiscordApi.shared.getMessages(channelId: "1013883033486639187") { result in
            switch result {
            case .success(let messages):
                self.messages = messages
                messages.forEach { message in
                    print(message.content)
                }
            case .failure(let err):
                err.presetErrorAlert(viewController: self)
            }
        }
    }
    
    private func configureTableView() {
        tableView.register(MessageTableViewCell.self, forCellReuseIdentifier: MessageTableViewCell.nameOfClass)
        tableView.rowHeight = 300.0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        messages.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MessageTableViewCell.nameOfClass, for: indexPath) as? MessageTableViewCell else { return UITableViewCell() }
        cell.setMessage(messages[indexPath.row])
        
        return cell
    }
    
   
}
