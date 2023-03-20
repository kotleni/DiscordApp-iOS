//
//  Extensions.swift
//  DiscordApp
//
//  Created by Victor Varenik on 20.03.2023.
//

import UIKit
import CommonCrypto

extension NSObject {
    
    class var nameOfClass: String {
        NSStringFromClass(self).components(separatedBy: ".").last!
    }
}

extension UIViewController {
///returns navigationBar height
    var navigationBarHeight: CGFloat {
        return (view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0.0) +
            (self.navigationController?.navigationBar.frame.height ?? 0.0)
    }
 ///returns full status bar heigh
    var statusBarHeight: CGFloat {
        var statusBarHeight: CGFloat = 0
           if #available(iOS 13.0, *) {
               let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
               statusBarHeight = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
           } else {
               statusBarHeight = UIApplication.shared.statusBarFrame.height
           }
           return statusBarHeight
       }
    }

extension Error {
    func presetErrorAlert(viewController: UIViewController) {
        let alert = UIAlertController(title: "Error", message: self.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .destructive, handler: { action in }))
        viewController.present(alert, animated: true, completion: nil)
    }
}

extension URLResponse {
    func verify() -> NetworkingError? {
        guard let code, let url else {
            return .invalidRequest(url)
        }
        switch code {
        case 200...299:
            return nil
        default:
            let localizedString = HTTPURLResponse.localizedString(forStatusCode: code)
            let description = "\(url) - \(code) - \(localizedString)"
            return .badStatusCode(description, code: code)
        }
    }
    
    var code: Int? {
        if let http = self as? HTTPURLResponse {
            return http.statusCode
        } else {
            return nil
        }
    }
}

extension NSLock {
    func sync<T>(_ closure: () -> T) -> T {
        lock()
        defer { unlock() }
        return closure()
    }
}

// MARK: - Staging
/// DataCache allows for parallel reads and writes. This is made possible by
/// DataCacheStaging.
///
/// For example, when the data is added in cache, it is first added to staging
/// and is removed from staging only after data is written to disk. Removal works
/// the same way.
struct Staging {
    private(set) var changes = [String: Change]()
    private(set) var changeRemoveAll: ChangeRemoveAll?

    struct ChangeRemoveAll {
        let id: Int
    }

    struct Change {
        let key: String
        let id: Int
        let type: ChangeType
    }

    enum ChangeType {
        case add(Data)
        case remove
    }

    private var nextChangeId = 0

    // MARK: Changes
    func change(for key: String) -> ChangeType? {
        if let change = changes[key] {
            return change.type
        }
        if changeRemoveAll != nil {
            return .remove
        }
        return nil
    }

    // MARK: Register Changes
    mutating func add(data: Data, for key: String) {
        nextChangeId += 1
        changes[key] = Change(key: key, id: nextChangeId, type: .add(data))
    }

    mutating func removeData(for key: String) {
        nextChangeId += 1
        changes[key] = Change(key: key, id: nextChangeId, type: .remove)
    }

    mutating func removeAll() {
        nextChangeId += 1
        changeRemoveAll = ChangeRemoveAll(id: nextChangeId)
        changes.removeAll()
    }

    // MARK: Flush Changes
    mutating func flushed(_ staging: Staging) {
        for change in staging.changes.values {
            flushed(change)
        }
        if let change = staging.changeRemoveAll {
            flushed(change)
        }
    }

    mutating func flushed(_ change: Change) {
        if let index = changes.index(forKey: change.key),
            changes[index].value.id == change.id {
            changes.remove(at: index)
        }
    }

    mutating func flushed(_ change: ChangeRemoveAll) {
        if changeRemoveAll?.id == change.id {
            changeRemoveAll = nil
        }
    }
}

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
}
