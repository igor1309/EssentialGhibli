//
//  FeedCache.swift
//  
//
//  Created by Igor Malyarov on 09.10.2022.
//

import Domain
import Foundation

public final class FeedCache<Item> {
    
    public typealias Validate = (Date, Date) -> Bool
    
    private let store: FeedStore
    private let toLocal: (Item) -> LocalFilm
    private let fromLocal: (LocalFilm) -> Item
    private let validate: Validate
    
    public init(
        store: FeedStore,
        toLocal: @escaping (Item) -> LocalFilm,
        fromLocal: @escaping (LocalFilm) -> Item,
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
        store: FeedStore,
        toLocal: @escaping (Item) -> LocalFilm,
        fromLocal: @escaping (LocalFilm) -> Item,
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
