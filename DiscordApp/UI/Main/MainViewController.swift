//
//  MainViewController.swift
//  DiscordApp
//
//  Created by Victor Varenik on 20.03.2023.
//

import UIKit

// MARK: UIViewController
final class MainViewController: UIViewController {
    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: createCollectionLayout())
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 224/255, green: 225/255, blue: 229/255, alpha: 1.0)
        view.register(GuildViewCell.self, forCellWithReuseIdentifier: "guild")
        view.delegate = self
        view.dataSource = self
        return view
    }()
    
    private var guilds: [Guild] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 228/255, green: 229/255, blue: 241/255, alpha: 1.0)
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.widthAnchor.constraint(equalToConstant: 90),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
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
                self?.collectionView.reloadData()
            }
        }
    }
    
    private func createCollectionLayout() -> UICollectionViewCompositionalLayout {
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
        return guilds.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "guild", for: indexPath) as! GuildViewCell
        let guildId = guilds[indexPath.row].id
        guard let guildIcon = guilds[indexPath.row].icon else { return cell }
        let url = "https://cdn.discordapp.com/icons/\(guildId)/\(String(describing: guildIcon)).png"
        print(url)
        cell.configure(url: url)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
}

// MARK: UICollectionViewDelegate
extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! GuildViewCell
        cell.select()
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! GuildViewCell
        cell.deselect()
    }
}
