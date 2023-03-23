//
//  DividerView.swift
//  DiscordApp
//
//  Created by Victor Varenik on 20.03.2023.
//

import UIKit

class DividerView: UIView {
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let bpath: UIBezierPath = UIBezierPath(rect: rect)
        Assets.Colors.divider.color.set()
        bpath.fill()
    }
}
