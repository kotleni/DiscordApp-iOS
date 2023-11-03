//
//  KeychainStorage.swift
//  DiscordApp
//
//  Created by Viktor Varenik on 21.03.2023.
//

import Foundation

@propertyWrapper
public struct KeychainStorage<T: Codable> {
    private let key: String
    private let defaultValue: T
    
    public init(key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }

    public var wrappedValue: T {
        get {
            guard let data = getData(for: key) else {
                return defaultValue
            }

            let value = try? JSONDecoder().decode(T.self, from: data)
            return value ?? defaultValue
        }
        set {
            let data = try? JSONEncoder().encode(newValue)
            set(data: data, for: key)
        }
    }
    
    private func getData(for key: String) -> Data? {
        let query = [
            kSecAttrSynchronizable: true,
            kSecAttrService: key,
            kSecClass: kSecClassGenericPassword,
            kSecMatchLimit: kSecMatchLimitOne,
            kSecReturnData: true,
            kSecAttrAccessible: kSecAttrAccessibleAfterFirstUnlock
        ] as CFDictionary
        var result: AnyObject?
        SecItemCopyMatching(query, &result)
        return (result as? Data)
    }
    
    private let lock = NSRecursiveLock()

    private func set(data: Data?, for key: String) {
        lock.lock()
        defer { lock.unlock() }
        if let data = data {
            let query = [
                kSecValueData: data,
                kSecAttrSynchronizable: true,
                kSecAttrService: key,
                kSecClass: kSecClassGenericPassword,
                kSecAttrAccessible: kSecAttrAccessibleAfterFirstUnlock
            ] as CFDictionary

            // Add data in query to keychain
            let status = SecItemAdd(query, nil)
            
            if status == errSecDuplicateItem {
                // Item already exist, thus update it.
                let query = [
                    kSecAttrSynchronizable: true,
                    kSecAttrService: key,
                    kSecClass: kSecClassGenericPassword,
                    kSecAttrAccessible: kSecAttrAccessibleAfterFirstUnlock
                ] as CFDictionary

                let attributesToUpdate = [kSecValueData: data] as CFDictionary

                // Update existing item
                SecItemUpdate(query, attributesToUpdate)
            }
        }
    }
}

