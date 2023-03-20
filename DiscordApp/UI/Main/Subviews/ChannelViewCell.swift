//
//  ChannelViewCell.swift
//  DiscordApp
//
//  Created by Victor Varenik on 20.03.2023.
//

import UIKit

class ChannelViewCell: UICollectionViewCell {
    private let nameLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .boldSystemFont(ofSize: 18)
        return view
    }()
    
    private let dividerView: DividerView = {
        let view = DividerView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var isCellSelected: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(nameLabel)
        contentView.addSubview(dividerView)
        
        let padding = 8.0
        NSLayoutConstraint.activate([
            nameLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: padding),
            nameLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -padding),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding),
            
            dividerView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: padding),
            dividerView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            dividerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            dividerView.heightAnchor.constraint(equalToConstant: 1),
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(name: String) {
        nameLabel.text = "#\(name)"
    }
}
