//
//  CoreDataFeedStore+FeedStore.swift
//  
//
//  Created by Igor Malyarov on 10.10.2022.
//

import GhibliCache
import Foundation

extension CoreDataFeedStore: FeedStore {
    
    public func retrieve() throws -> CachedFeed<LocalFilm>? {
        try performSync { context in
            Result {
                try ManagedCache.find(in: context).map { cache in
                    (feed: cache.localFeed, timestamp: cache.timestamp)
                }
            }
        }
    }
    
    public func insert(_ feed: [LocalFilm], timestamp: Date) throws {
        try performSync { context in
            Result {
                let managedCache = try ManagedCache.newUniqueInstance(in: context)
                managedCache.feed = ManagedFilmImage.images(from: feed, in: context)
                managedCache.timestamp = timestamp
                try context.save()
            }
        }
    }
    
    public func deleteCachedFeed() throws {
        try performSync { context in
            Result {
                try ManagedCache.find(in: context).map(context.delete).map(context.save)
            }
        }
    }
}
