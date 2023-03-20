//
//  GuildViewCell.swift
//  DiscordApp
//
//  Created by Victor Varenik on 20.03.2023.
//

import UIKit

class GuildViewCell: UICollectionViewCell {
    private let imageView: RoundedImageView = {
        let view = RoundedImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        
        let padding = 10.0
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding),
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor)
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    func configure(url: String) {
        imageView.loadImageUsingCache(withUrl: url)
    }
}
