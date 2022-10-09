//
//  FeedLoader.swift
//  
//
//  Created by Igor Malyarov on 09.10.2022.
//

import Foundation

public typealias CachedFeed<Item> = (feed: [Item], timestamp: Date)

public protocol FeedStore {
    associatedtype Item
    
    func retrieve() throws -> CachedFeed<Item>
}

public final class FeedLoader<Item, Store>
where Store: FeedStore,
      Store.Item == Item {
    
    public typealias Validate = (Date, Date) -> Bool
    
    private let store: Store
    private let validate: Validate
    
    public init(store: Store, validate: @escaping Validate) {
        self.store = store
        self.validate = validate
    }
    
    public init(store: Store, feedCachePolicy: FeedCachePolicy = .sevenDays) {
        self.store = store
        self.validate = feedCachePolicy.validate
    }

    public func load() throws -> [Item] {
        let cached = try store.retrieve()

        return validate(.now, cached.timestamp) ? cached.feed : []
    }
}
