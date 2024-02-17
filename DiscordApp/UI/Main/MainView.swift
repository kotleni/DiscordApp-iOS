//
//  MainView.swift
//  DiscordApp
//
//  Created by Viktor Varenik on 17.02.2024.
//

import UIKit

final class MainView: UIView {
    var guildsCollectionView: UICollectionView = {
        let layout = UICollectionViewCompositionalLayout(sectionProvider: { _, _ in
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
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        view.backgroundColor = .clear
        view.register(GuildViewCell.self, forCellWithReuseIdentifier: "guild")
        return view
    }()
    
    var channelsCollectionView: UICollectionView = {
        let layout = UICollectionViewCompositionalLayout(sectionProvider: { _, _ in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(40))
            let group: NSCollectionLayoutGroup
            if #available(iOS 16.0, *) {
                group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: 1)
            } else {
                group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
            }
            let section = NSCollectionLayoutSection(group: group)
            return section
        })
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        view.backgroundColor = Assets.Colors.plane.color
        view.layer.cornerRadius = 8.0
        view.layer.masksToBounds = true
        view.register(ChannelViewCell.self, forCellWithReuseIdentifier: "channel")
        return view
    }()
//    private let loadingAlert = UIAlertController(title: nil, message: Text.alertWaitloading, preferredStyle: .alert)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = Assets.Colors.background.color
        [guildsCollectionView, channelsCollectionView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            guildsCollectionView.topAnchor.constraint(equalTo: topAnchor),
            guildsCollectionView.leftAnchor.constraint(equalTo: leftAnchor),
            guildsCollectionView.widthAnchor.constraint(equalToConstant: 70),
            guildsCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            channelsCollectionView.leftAnchor.constraint(equalTo: guildsCollectionView.rightAnchor),
            channelsCollectionView.rightAnchor.constraint(equalTo: rightAnchor, constant: -8),
            channelsCollectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            channelsCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
