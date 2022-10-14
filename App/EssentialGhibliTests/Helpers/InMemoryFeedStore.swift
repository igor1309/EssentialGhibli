//
//  InMemoryFeedStore.swift
//  EssentialGhibliTests
//
//  Created by Igor Malyarov on 15.10.2022.
//

import Cache
import Foundation
import ListFeature

final class InMemoryFeedStore: FeedStore {
    typealias Item = ListFilm
    
    private var cached: CachedFeed<ListFilm>?
    
    init(cached: CachedFeed<ListFilm>?) {
        self.cached = cached
    }
    
    func deleteCachedFeed() throws {
        cached = nil
    }
    
    func insert(_ feed: [ListFeature.ListFilm], timestamp: Date) throws {
        cached = (feed, timestamp)
    }
    
    func retrieve() throws -> Cache.CachedFeed<ListFilm>? {
        cached
    }
}
