//
//  FeedStore.swift
//  
//
//  Created by Igor Malyarov on 12.10.2022.
//

import Foundation

public typealias CachedFeed<Item> = (feed: [Item], timestamp: Date)

public protocol FeedStore<Item> {
    associatedtype Item
    
    func deleteCachedFeed() throws
    func insert(_ feed: [Item], timestamp: Date) throws
    func retrieve() throws -> CachedFeed<Item>?
}
