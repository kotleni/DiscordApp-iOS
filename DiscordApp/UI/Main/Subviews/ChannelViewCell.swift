//
//  ChannelViewCell.swift
//  DiscordApp
//
//  Created by Viktor Varenik on 20.03.2023.
//

import UIKit

class ChannelViewCell: UICollectionViewCell {
    private let iconImage: UIImageView = {
        let view = UIImageView()
        view.contentMode = .center
        view.image = UIImage(systemName: "number")
        return view
    }()
    
    private let nameLabel: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 16)
        return view
    }()
    
    private var isCellSelected: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        [iconImage, nameLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        let padding = 8.0
        NSLayoutConstraint.activate([
            iconImage.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: padding),
            iconImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            iconImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding),
            iconImage.widthAnchor.constraint(equalTo: contentView.heightAnchor),
            
            nameLabel.leftAnchor.constraint(equalTo: iconImage.rightAnchor, constant: padding),
            nameLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -padding),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding)
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(name: String) {
        nameLabel.text = "\(name)"
    }
}
