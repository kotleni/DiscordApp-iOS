//
//  GuildSelectView.swift
//  DiscordApp
//
//  Created by Viktor Varenik on 20.03.2023.
//

import UIKit

class GuildSelectView: UIView {
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let color: UIColor = Assets.Colors.guildSelector.color
        let bpath: UIBezierPath = UIBezierPath(rect: rect)
        color.set()
        bpath.fill()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = min(bounds.width, bounds.height) / 2
        layer.masksToBounds = true
    }
}
