//
//  InMemoryFeedStore.swift
//  EssentialGhibliTests
//
//  Created by Igor Malyarov on 15.10.2022.
//

import Cache
import Foundation
import ListFeature

final class InMemoryFeedStore {
    typealias Item = ListFilm
    
    private var cached: CachedFeed<ListFilm>?
    
    init(cached: CachedFeed<ListFilm>?) {
        self.cached = cached
    }
}

extension InMemoryFeedStore {
    static func empty() -> InMemoryFeedStore {
        .init(cached: nil)
    }
    
    static func samples() -> InMemoryFeedStore {
        .init(cached: (.samples, .now))
    }
}

extension InMemoryFeedStore: FeedStore {
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

extension InMemoryFeedStore: FilmImageDataStore {
    func retrieve(dataForURL url: URL) throws -> Data? {
        fatalError()
    }
    
    func insert(_ data: Data, for url: URL) throws {
        fatalError()
    }
}
