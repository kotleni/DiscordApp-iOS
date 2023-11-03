//
//  NSObject.swift
//  DiscordApp
//
//  Created by Viktor Varenik on 21.03.2023.
//

import Foundation

extension NSObject {
    class var nameOfClass: String {
        NSStringFromClass(self).components(separatedBy: ".").last!
    }
}
