//
//  ChannelsViewController.swift
//  DiscordApp
//
//  Created by Victor Varenik on 19.03.2023.
//

import UIKit

final class ChannelsViewController: UITableViewController {
    private var guildId: String = ""
    private var channels: [Channel] = []
    
    convenience init(guildId: String) {
        self.init()
        self.guildId = guildId
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DiscordApi.shared.getChannels(guildId: guildId) { channels in
            self.channels = channels
            self.tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        channels.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = channels[indexPath.row].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigationController?.pushViewController(MessagesViewController(channelId: channels[indexPath.row].id), animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
