//
//  CircularButton.swift
//  DiscordApp
//
//  Created by Вячеслав Макаров on 21.03.2023.
//

import UIKit


final class CircularButton: UIButton {
    
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = min(bounds.width, bounds.height) / 2
        layer.masksToBounds = true
    }
}
