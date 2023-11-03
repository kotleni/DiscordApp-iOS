//
//  String.swift
//  DiscordApp
//
//  Created by Viktor Varenik on 21.03.2023.
//

import Foundation
import CommonCrypto

extension String {
    /// Calculates SHA1 from the given string and returns its hex representation.
    ///
    /// ```swift
    /// print("http://test.com".sha1)
    /// // prints "50334ee0b51600df6397ce93ceed4728c37fee4e"
    /// ```
    var sha1: String? {
        guard !isEmpty, let input = self.data(using: .utf8) else {
            return nil
        }

        let hash = input.withUnsafeBytes { (bytes: UnsafeRawBufferPointer) -> [UInt8] in
            var hash = [UInt8](repeating: 0, count: Int(CC_SHA1_DIGEST_LENGTH))
            CC_SHA1(bytes.baseAddress, CC_LONG(input.count), &hash)
            return hash
        }

        return hash.map({ String(format: "%02x", $0) }).joined()
    }
    
    /// Get localized string
    var localized: String {
        return NSLocalizedString(self, bundle: Bundle(for: BundleClass.self), comment: "")
    }
    
    func localizedWithPlaceholder(arguments: CVarArg...) -> String {
        return String(format: self, arguments)
    }
}

// Neded for .localized
private class BundleClass { }
