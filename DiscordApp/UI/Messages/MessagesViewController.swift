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
    
    private var channel: Channel?
    private let rotationAngle = Double.pi     // 180˚ in radians
    private let watchdogTimerDelay = 1.5      // in secs
    
    private var messages: [Message] = []
    
    convenience init(channel: Channel) {
        self.init()
        self.channel = channel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "Background")
        tableView.backgroundColor = .clear
        title = channel?.name ?? "Text channel"
        edgesForExtendedLayout = .all
        
        [tableView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        setUpConstraints()
    }
   
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startWatchdog()
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }
    
    @objc private func updateChat() {
        getMessages()
    }
    
    private func startWatchdog() {
        Timer.scheduledTimer(timeInterval: watchdogTimerDelay, target: self, selector: #selector(updateChat), userInfo: nil, repeats: true)
    }
    
    private func getMessages() {
        guard let channelId = channel?.id else { return }
        DiscordApi.shared.getMessages(channelId: channelId) { result in
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
        return messages.count
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
