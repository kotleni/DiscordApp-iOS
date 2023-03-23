//
//  MessageFieldView.swift
//  DiscordApp
//
//  Created by Victor Varenik on 23.03.2023.
//

import UIKit

final class MessageFiledView: UITextField {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        borderStyle = .none
        backgroundColor = Assets.Colors.messageFieldBackground.color
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 9
        layer.masksToBounds = true
        layer.sublayerTransform = CATransform3DMakeTranslation(6, 0, 0)
    }
}
