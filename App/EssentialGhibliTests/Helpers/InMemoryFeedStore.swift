//
//  InMemoryFeedStore.swift
//
//
//  Created by Igor Malyarov on 15.10.2022.
//

import Cache
import Foundation
import ListFeature

final class InMemoryFeedStore {
    private var cached: CachedFeed?
    
    init(cached: CachedFeed?) {
        self.cached = cached
    }
}

extension InMemoryFeedStore {
    static func empty() -> InMemoryFeedStore {
        .init(cached: nil)
    }
    
    static func samples() -> InMemoryFeedStore {
        .init(cached: ([ListFilm].samples.map(LocalFilm.init), .now))
    }
}

extension InMemoryFeedStore: FeedStore {
    func deleteCachedFeed() throws {
        cached = nil
    }
    
    func insert(_ feed: [Cache.LocalFilm], timestamp: Date) throws {
        cached = (feed, timestamp)
    }

    func retrieve() throws -> Cache.CachedFeed? {
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
