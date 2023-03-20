//
//  MessagesViewController.swift
//  DiscordApp
//
//  Created by Victor Varenik on 19.03.2023.
//

import UIKit

final class MessagesViewController: UITableViewController {
    private var channelId: String = ""
    private var messages: [Message] = []
    
    convenience init(channelId: String) {
        self.init()
        self.channelId = channelId
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let radians = Double.pi / 180.0 * 180.0
        view.transform = CGAffineTransform(rotationAngle: radians)
        
        DiscordApi.shared.getMessages(channelId: channelId) { [weak self] result in
            switch result {
            case .failure(let err):
                guard let self = self else { return }
                err.presetErrorAlert(viewController: self)
            case .success(let messages):
                self?.messages = messages
                self?.tableView.reloadData()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        messages.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "\(messages[indexPath.row].author.username) : \(messages[indexPath.row].content)"
        let radians = Double.pi / 180.0 * 180.0
        cell.transform = CGAffineTransform(rotationAngle: radians)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
