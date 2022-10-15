//
//  CodableFeedStore.swift
//  
//
//  Created by Igor Malyarov on 10.10.2022.
//

import Cache
import Foundation

public final class CodableFeedStore: FeedStore {
    private let storeURL: URL
    
    public init(storeURL: URL) {
        self.storeURL = storeURL
    }
    
    private struct Cache: Codable {
        private let feed: [CachedFilm]
        private let timestamp: Date
        
        init(local: [LocalFilm], timestamp: Date) {
            self.feed = local.map(CachedFilm.init)
            self.timestamp = timestamp
        }
        
        var localFeed: (feed: [LocalFilm], timestamp: Date) {
            (feed.map(\.local), timestamp)
        }
        
        private struct CachedFilm: Codable {
            private let id: UUID
            private let title: String
            private let description: String
            private let imageURL: URL
            private let filmURL: URL
            
            init(local: LocalFilm) {
                self.id = local.id
                self.title = local.title
                self.description = local.description
                self.imageURL = local.imageURL
                self.filmURL = local.filmURL
            }
            
            var local: LocalFilm {
                .init(
                    id: id,
                    title: title,
                    description: description,
                    imageURL: imageURL,
                    filmURL: filmURL
                )
            }
        }
    }
    
    public func deleteCachedFeed() throws {
        try FileManager.default.removeItem(at: storeURL)
    }
    
    public func insert(_ feed: [LocalFilm], timestamp: Date) throws {
        let encoder = JSONEncoder()
        let cache = Cache(local: feed, timestamp: timestamp)
        let encoded = try encoder.encode(cache)
        try encoded.write(to: storeURL)
    }
    
    public func retrieve() throws -> CachedFeed? {
        guard let data = try? Data(contentsOf: storeURL)
        else { return nil }
        
        let decoder = JSONDecoder()
        let cache = try decoder.decode(Cache.self, from: data)
        
        return cache.localFeed
    }
}
