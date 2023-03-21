//
//  MainViewController.swift
//  DiscordApp
//
//  Created by Victor Varenik on 20.03.2023.
//

import UIKit

// MARK: UIViewController
final class MainViewController: UIViewController {
    private lazy var guildsCollectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: createGuildCollectionLayout())
        
        view.backgroundColor = UIColor(named: "Bar")
        view.register(GuildViewCell.self, forCellWithReuseIdentifier: "guild")
        view.delegate = self
        view.dataSource = self
        return view
    }()
    
    private lazy var channelsCollectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: createChannelCollectionLayout())
        
        view.backgroundColor = .clear
        view.register(ChannelViewCell.self, forCellWithReuseIdentifier: "channel")
        view.delegate = self
        view.dataSource = self
        return view
    }()
    private let loadingAlert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
    
    private var guilds: [Guild] = []
    private var channels: [Channel] = []
    private var currentGuildIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "Background")
        [guildsCollectionView, channelsCollectionView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            guildsCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            guildsCollectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            guildsCollectionView.widthAnchor.constraint(equalToConstant: 90),
            guildsCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            channelsCollectionView.leftAnchor.constraint(equalTo: guildsCollectionView.rightAnchor),
            channelsCollectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            channelsCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            channelsCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setLoading(isLoading: true)
        DiscordApi.shared.getGuilds { [weak self] result in
            switch result {
            case .failure(let err):
                guard let self = self else { return }
                err.presetErrorAlert(viewController: self)
            case .success(let guilds):
                self?.guilds = guilds.sorted(by: { first, _ in
                    guard let isOwner = first.owner else { return false }
                    return isOwner // owned first
                })
                self?.guildsCollectionView.reloadData()
                
                self?.setLoading(isLoading: false)
            }
        }
    }
    
    private func setLoading(isLoading: Bool) {
        switch isLoading {
        case true:
            let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
            loadingIndicator.style = .medium
            loadingIndicator.startAnimating()

            loadingAlert.view.addSubview(loadingIndicator)
            present(loadingAlert, animated: true)
        case false:
            loadingAlert.dismiss(animated: true)
        }
    }
    
    private func loadChannelsFor(guildId: String) {
        setLoading(isLoading: true)
        
        DiscordApi.shared.getChannels(guildId: guildId) { [weak self] result in
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
                self?.channelsCollectionView.reloadData()
                
                // Try find guild index by id
                self?.currentGuildIndex = self?.guilds.firstIndex(where: { $0.id == guildId })
            }
            
            self?.setLoading(isLoading: false)
        }
    }
    
    private func createGuildCollectionLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout(sectionProvider: { _, _ in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(70))
            let group: NSCollectionLayoutGroup
            if #available(iOS 16.0, *) {
                group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: 1)
            } else {
                group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
            }
            let section = NSCollectionLayoutSection(group: group)
            return section
        })
    }
    
    private func createChannelCollectionLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout(sectionProvider: { _, _ in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(70))
            let group: NSCollectionLayoutGroup
            if #available(iOS 16.0, *) {
                group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: 1)
            } else {
                group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
            }
            let section = NSCollectionLayoutSection(group: group)
            return section
        })
    }
}

// MARK: UICollectionViewDataSource
extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case guildsCollectionView:
            return guilds.count
        case channelsCollectionView:
            return channels.count
        default:
            fatalError("Wrong collection view")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case guildsCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "guild", for: indexPath) as! GuildViewCell
            let guild = guilds[indexPath.row]
            guard let url = guild.getIconUrl() else { return cell }
            cell.configure(url: url)
            return cell
        case channelsCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "channel", for: indexPath) as! ChannelViewCell
            guard let channelName = channels[indexPath.row].name else { return cell }
            cell.configure(name: channelName)
            return cell
        default:
            fatalError("Wrong collection view")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch collectionView {
        case guildsCollectionView:
            return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        case channelsCollectionView:
            return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        default:
            fatalError("Wrong collection view")
        }
    }
}

// MARK: UICollectionViewDelegate
extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case guildsCollectionView:
            let cell = collectionView.cellForItem(at: indexPath) as! GuildViewCell
            cell.select()
            
            let guildId = guilds[indexPath.row].id
            loadChannelsFor(guildId: guildId)
        case channelsCollectionView:
            let channel = channels[indexPath.row]
            navigationController?.pushViewController(MessagesViewController(channel: channel), animated: true)
        default:
            fatalError("Wrong collection view")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        switch collectionView {
        case guildsCollectionView:
            let cell = collectionView.cellForItem(at: indexPath) as! GuildViewCell
            cell.deselect()
        default:
            fatalError("Wrong collection view")
        }
    }
}
