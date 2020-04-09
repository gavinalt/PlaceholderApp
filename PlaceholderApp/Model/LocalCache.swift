//
//  Cache.swift
//  PlaceholderApp
//
//  Created by Gavin Li on 4/8/20.
//  Copyright © 2020 Gavin Li. All rights reserved.
//

import Foundation

final class LocalCache<Key: Hashable, Value> {
    
    private let wrapped = NSCache<WrappedKey, Entry>()
    private let keyTracker = KeyTracker()
    
    init(maximumEntryCount: Int = 500) {
        wrapped.countLimit = maximumEntryCount
        wrapped.delegate = keyTracker
    }
    
    func insert(_ value: Value, forKey key: Key) {
        let entry = Entry(key: key, value: value)
        wrapped.setObject(entry, forKey: WrappedKey(key))
        keyTracker.keys.insert(key)
    }
    
    func value(forKey key: Key) -> Value? {
        let entry = wrapped.object(forKey: WrappedKey(key))
        return entry?.value
    }
    
    func removeValue(forKey key: Key) {
        wrapped.removeObject(forKey: WrappedKey(key))
    }
}

extension LocalCache {
    subscript(key: Key) -> Value? {
        get { return value(forKey: key) }
        set {
            guard let value = newValue else {
                // If nil was assigned using our subscript, then we remove any value for that key:
                removeValue(forKey: key)
                return
            }
            
            insert(value, forKey: key)
        }
    }
}

private extension LocalCache {
    final class WrappedKey: NSObject {
        let key: Key
        init(_ key: Key) { self.key = key }
        
        override var hash: Int { return key.hashValue }
        
        override func isEqual(_ object: Any?) -> Bool {
            guard let value = object as? WrappedKey else { return false }
            return value.key == key
        }
    }
}

private extension LocalCache {
    final class Entry {
        let key: Key
        let value: Value
        
        init(key: Key, value: Value) {
            self.key = key
            self.value = value
        }
    }
    
    func entry(forKey key: Key) -> Entry? {
        guard let entry = wrapped.object(forKey: WrappedKey(key)) else { return nil }
        return entry
    }
    
    func insert(_ entry: Entry) {
        wrapped.setObject(entry, forKey: WrappedKey(entry.key))
        keyTracker.keys.insert(entry.key)
    }
}

private extension LocalCache {
    final class KeyTracker: NSObject, NSCacheDelegate {
        var keys = Set<Key>()
        
        func cache(_ cache: NSCache<AnyObject, AnyObject>, willEvictObject object: Any) {
            guard let entry = object as? Entry else { return }
            keys.remove(entry.key)
        }
    }
}

extension LocalCache.Entry: Codable where Key: Codable, Value: Codable {}

extension LocalCache: Codable where Key: Codable, Value: Codable {
    convenience init(from decoder: Decoder) throws {
        self.init()
        
        let container = try decoder.singleValueContainer()
        let entries = try container.decode([Entry].self)
        entries.forEach(insert)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(keyTracker.keys.compactMap(entry))
    }
}

extension LocalCache where Key: Codable, Value: Codable {
    static func persistencePath(withName name: String, using fileManager: FileManager) -> URL {
        let folderURLs = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)
        return folderURLs[0].appendingPathComponent(name + ".cache")
    }
    
    func saveToDisk(withName name: String, using fileManager: FileManager = .default) throws {
        let fileURL = LocalCache.persistencePath(withName: name, using: fileManager)
        let data = try JSONEncoder().encode(self)
        try data.write(to: fileURL)
    }
}
