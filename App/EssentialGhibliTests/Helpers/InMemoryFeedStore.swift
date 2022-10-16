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
    private(set) var feedCache: CachedFeed?
    private var filmImageDataCache: [URL: Data] = [:]
    
    private init(feedCache: CachedFeed? = nil) {
        self.feedCache = feedCache
    }
}

extension InMemoryFeedStore {
    static func empty() -> InMemoryFeedStore { .init() }
    
    static func withExpiredFeedCache() -> InMemoryFeedStore {
        .init(feedCache: (feed: [], timestamp: Date.distantPast))
    }
    
    static func withNonExpiredFeedCache() -> InMemoryFeedStore {
        .init(feedCache: (.samples, .now))
    }
}

private extension Array where Element == LocalFilm {
    static let samples: Self = [ListFilm].samples.map(LocalFilm.init)
}

extension InMemoryFeedStore: FeedStore {
    func deleteCachedFeed() throws {
        feedCache = nil
    }
    
    func insert(_ feed: [Cache.LocalFilm], timestamp: Date) throws {
        feedCache = (feed, timestamp)
    }

    func retrieve() throws -> Cache.CachedFeed? {
        feedCache
    }
}

extension InMemoryFeedStore: FilmImageDataStore {
    func retrieve(dataForURL url: URL) throws -> Data? {
        filmImageDataCache[url]
    }
    
    func insert(_ data: Data, for url: URL) throws {
        filmImageDataCache[url] = data
    }
}
