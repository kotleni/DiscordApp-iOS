//
//  NSLock.swift
//  DiscordApp
//
//  Created by Viktor Varenik on 21.03.2023.
//

import Foundation

extension NSLock {
    func sync<T>(_ closure: () -> T) -> T {
        lock()
        defer { unlock() }
        return closure()
    }
}
