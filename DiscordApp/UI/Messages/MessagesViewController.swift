//
//  MessagesViewController.swift
//  DiscordApp
//
//  Created by Вячеслав Макаров on 20.03.2023.
//

import UIKit

// MARK: UIViewController
final class MessagesViewController: ViewController<MessagesView> {
    private var channel: DiscordChannel?
    private let watchdogTimerDelay = 1.5      // in secs
    
    private var messages: [DiscordMessage] = []
    
    var coordinator: Coordinator?
    
    convenience init(channel: DiscordChannel) {
        self.init()
        self.channel = channel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        title = channel?.name ?? "????"
        edgesForExtendedLayout = .all
        
        mainView.messageSendButton.addTarget(self, action: #selector(sendMessage), for: .touchDown)
        
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
    }
   
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setLoading(isLoading: true)
        startWatchdog()
    }
    
    @objc
    private func sendMessage(sender: CircularButton) {
        DiscordClient.sendMessage(channelId: channel!.id, text: mainView.messageTextField.text ?? "") { [self] in
            mainView.messageTextField.text = ""
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
                    self.mainView.tableView.reloadData()
                    self.setLoading(isLoading: false)
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
