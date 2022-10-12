//
//  FeedCache.swift
//  
//
//  Created by Igor Malyarov on 09.10.2022.
//

import GhibliDomain
import Foundation

public final class FeedCache<Item, Store>
where Store: FeedStore {
    
    public typealias LocalItem = Store.Item
    public typealias Validate = (Date, Date) -> Bool
    
    private let store: Store
    private let toLocal: (Item) -> LocalItem
    private let fromLocal: (LocalItem) -> Item
    private let validate: Validate
    
    public init(
        store: Store,
        toLocal: @escaping (Item) -> LocalItem,
        fromLocal: @escaping (LocalItem) -> Item,
        validate: @escaping Validate
    ) {
        self.store = store
        self.toLocal = toLocal
        self.fromLocal = fromLocal
        self.validate = validate
    }
}

extension FeedCache {
    public convenience init(
        store: Store,
        toLocal: @escaping (Item) -> LocalItem,
        fromLocal: @escaping (LocalItem) -> Item,
        feedCachePolicy: FeedCachePolicy = .sevenDays
    ) {
        self.init(store: store, toLocal: toLocal, fromLocal: fromLocal, validate: feedCachePolicy.validate)
    }
}

extension FeedCache: FeedSaver {
    public func save(feed: [Item], timestamp: Date) throws {
        try store.deleteCachedFeed()
        try store.insert(feed.map(toLocal), timestamp: timestamp)
    }
}

extension FeedCache {
    public func load() throws -> [Item] {
        guard let cached = try store.retrieve() else {
            return []
        }
        
        return validate(.now, cached.timestamp) ? cached.feed.map(fromLocal) : []
    }
}

extension FeedCache {
    public func validateCache() throws {
        do {
            guard let cached = try store.retrieve() else {
                return
            }
            
            if !validate(.now, cached.timestamp) {
                try store.deleteCachedFeed()
            }
        } catch {
            try store.deleteCachedFeed()
            throw error
        }
    }
}
