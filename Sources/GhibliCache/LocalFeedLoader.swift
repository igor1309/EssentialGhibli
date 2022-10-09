//
//  LocalFeedLoader.swift
//  
//
//  Created by Igor Malyarov on 09.10.2022.
//

import Foundation

public typealias CachedFeed<Item> = (feed: [Item], timestamp: Date)

public protocol FeedStore {
    associatedtype Item
    
    func deleteCachedFeed() throws
    func insert(_ feed: [Item], timestamp: Date) throws
    func retrieve() throws -> CachedFeed<Item>
}

public final class LocalFeedLoader<Item, Store>
where Store: FeedStore {
    
    public typealias Validate = (Date, Date) -> Bool
    
    private let store: Store
    private let toCached: (Item) -> Store.Item
    private let fromCached: (Store.Item) -> Item
    private let validate: Validate
    
    public init(
        store: Store,
        toCached: @escaping (Item) -> Store.Item,
        fromCached: @escaping (Store.Item) -> Item,
        validate: @escaping Validate
    ) {
        self.store = store
        self.toCached = toCached
        self.fromCached = fromCached
        self.validate = validate
    }
    
    public convenience init(
        store: Store,
        toCached: @escaping (Item) -> Store.Item,
        fromCached: @escaping (Store.Item) -> Item,
        feedCachePolicy: FeedCachePolicy = .sevenDays
    ) {
        self.init(store: store, toCached: toCached, fromCached: fromCached, validate: feedCachePolicy.validate)
    }
    
    public func save(feed: [Item], timestamp: Date) throws {
        try store.deleteCachedFeed()
        try store.insert(feed.map(toCached), timestamp: timestamp)
    }

    public func load() throws -> [Item] {
        let cached = try store.retrieve()

        return validate(.now, cached.timestamp) ? cached.feed.map(fromCached) : []
    }
    
    public func validateCache() throws {
        do {
            let cached = try store.retrieve()
            if !validate(.now, cached.timestamp) {
                try store.deleteCachedFeed()
            }
        } catch {
            try store.deleteCachedFeed()
            throw error
        }
    }
}
