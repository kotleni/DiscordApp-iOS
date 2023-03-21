//
//  GuildViewCell.swift
//  DiscordApp
//
//  Created by Victor Varenik on 20.03.2023.
//

import UIKit

class GuildViewCell: UICollectionViewCell {
    private let imageView: AvatarImageView = {
        let view = AvatarImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let selectorView: GuildSelectView = {
        let view = GuildSelectView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .red
        return view
    }()
    
    private var isCellSelected: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(imageView)
        contentView.addSubview(selectorView)
        
        let padding = 10.0
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding),
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),
            
            selectorView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            selectorView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: -4),
            selectorView.widthAnchor.constraint(equalToConstant: 8),
            selectorView.heightAnchor.constraint(equalTo: imageView.heightAnchor, constant: -10)
        ])
        
        selectorView.alpha = 0.0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    func configure(url: String) {
        imageView.loadImage(url)
    }
    
    func select() {
        isCellSelected = true
        
        UIView.animate(withDuration: 0.3) {
            self.selectorView.alpha = 1.0
        }
    }
    
    func deselect() {
        isCellSelected = false
        
        UIView.animate(withDuration: 0.3) {
            self.selectorView.alpha = 0.0
        }
    }
}
