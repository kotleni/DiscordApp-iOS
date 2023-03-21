//
//  Staging.swift
//  DiscordApp
//
//  Created by Victor Varenik on 21.03.2023.
//

import Foundation

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
