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
        
        let color: UIColor = UIColor.systemGray4
        let bpath: UIBezierPath = UIBezierPath(rect: rect)
        color.set()
        bpath.fill()
    }
}
