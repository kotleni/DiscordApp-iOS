//
//  ViewController.swift
//  DiscordApp
//
//  Created by Victor Varenik on 19.03.2023.
//

import UIKit

final class GuildsViewController: UITableViewController {
    private var guilds: [Guild] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DiscordApi.shared.getGuilds { guilds in
            self.guilds = guilds
            self.tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guilds.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = guilds[indexPath.row].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        navigationController?.pushViewController(ChannelsViewController(guildId: guilds[indexPath.row].id), animated: true)
    }
}
