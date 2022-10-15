//
//  FeedStore.swift
//  
//
//  Created by Igor Malyarov on 12.10.2022.
//

import Foundation

public typealias CachedFeed = (feed: [LocalFilm], timestamp: Date)

public protocol FeedStore {
    func deleteCachedFeed() throws
    func insert(_ feed: [LocalFilm], timestamp: Date) throws
    func retrieve() throws -> CachedFeed?
}
