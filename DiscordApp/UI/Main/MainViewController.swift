//
//  MainViewController.swift
//  DiscordApp
//
//  Created by Viktor Varenik on 20.03.2023.
//

import UIKit

// MARK: UIViewController
final class MainViewController: ViewController<MainView> {
    private var guilds: [DiscordGuild] = []
    private var channels: [DiscordChannel] = []
    private var currentGuildIndex: Int?
    
    var coordinator: Coordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        [mainView.guildsCollectionView, mainView.channelsCollectionView].forEach {
            $0.delegate = self
            $0.dataSource = self
        }
        
        if !TokenService.isValidToken {
            coordinator?.openAuth(with: self)
//            modalPresentationStyle = .popover
//            let authVC = AuthViewController()
//            authVC.delegate = self
//            present(authVC, animated: true)
        } else {
            fetchGuilds()
        }
    }
    
    private func fetchGuilds() {
        setLoading(isLoading: true)
        DiscordClient.getGuilds { [weak self] result in
            switch result {
            case .failure(let err):
                guard let self = self else { return }
                err.presetErrorAlert(viewController: self)
            case .success(let guilds):
                self?.guilds = guilds.sorted(by: { first, _ in
                    guard let isOwner = first.isOwner else { return false }
                    return isOwner // owned first
                })
                
                // TODO: Check
                // TODO: Temporary fix, loading alert can't close normally (if called now)
                self?.executeWhenViewAlreadyAppeared {
                    self?.mainView.guildsCollectionView.reloadData()
                    self?.setLoading(isLoading: false)
                }
            }
        }
    }
    
    private func fetchChannelsFor(guildId: String) {
        setLoading(isLoading: true)
        
        DiscordClient.getChannels(guildId: guildId) { [weak self] result in
            switch result {
            case .failure(let err):
                guard let self = self else { return }
                err.presetErrorAlert(viewController: self)
            case .success(let channels):
                self?.channels = channels.filter({ channel in
                    return channel.type == 0 // TODO: do channel types enum
                }).sorted(by: { first, second in
                    guard let firstPos = first.position, let secondPos = second.position
                    else { return false }
                    return firstPos > secondPos
                })
                self?.mainView.channelsCollectionView.reloadData()
                
                // Try find guild index by id
                self?.currentGuildIndex = self?.guilds.firstIndex(where: { $0.id == guildId })
            }
            
            self?.setLoading(isLoading: false)
        }
    }
}

// MARK: UICollectionViewDataSource
// TODO: Rewrite to separated classes
extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case mainView.guildsCollectionView:
            return guilds.count
        case mainView.channelsCollectionView:
            return channels.count
        default:
            fatalError("Wrong collection view")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case mainView.guildsCollectionView:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "guild",
                for: indexPath
            ) as? GuildViewCell
            guard let cell = cell else { fatalError("Cannon cast cell to GuildViewCell") }
            let guild = guilds[indexPath.row]
            cell.configure(name: guild.name, url: guild.getIconUrl())
            return cell
        case mainView.channelsCollectionView:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "channel",
                for: indexPath
            ) as? ChannelViewCell
            guard let cell = cell else { fatalError("Cannon cast cell to ChannelViewCell") }
            guard let channelName = channels[indexPath.row].name else { return cell }
            cell.configure(name: channelName)
            return cell
        default:
            fatalError("Wrong collection view")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        .init(top: 10, left: 10, bottom: 10, right: 10)
    }
}

// MARK: UICollectionViewDelegate
extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case mainView.guildsCollectionView:
            let cell = collectionView.cellForItem(at: indexPath) as? GuildViewCell
            guard let cell = cell else { fatalError("Cell cannon be casted to GuildViewCell") }
            cell.select()
            
            let guildId = guilds[indexPath.row].id
            fetchChannelsFor(guildId: guildId)
        case mainView.channelsCollectionView:
            let channel = channels[indexPath.row]
            coordinator?.openMessages(channel: channel)
        default:
            fatalError("Wrong collection view")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        switch collectionView {
        case mainView.guildsCollectionView:
            let cell = collectionView.cellForItem(at: indexPath) as? GuildViewCell
            guard let cell = cell else { fatalError("Cell cannon be casted to GuildViewCell") }
            cell.deselect()
        case mainView.channelsCollectionView:
            break
        default:
            fatalError("Wrong collection view")
        }
    }
}

extension MainViewController: AuthViewControllerDelegate {
    func authViewController(didAuth: Bool, token: String) {
        if didAuth {
            fetchGuilds()
        }
    }
}
