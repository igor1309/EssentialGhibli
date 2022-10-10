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
        let context = self.context
        
        return try context.performAndWait {
            if let cache = try ManagedCache.find(in: context) {
                return (feed: cache.localFeed, timestamp: cache.timestamp)
            } else {
                return nil
            }
        }
    }
    
    public func insert(_ feed: [LocalFilm], timestamp: Date) throws {
        let context = self.context
        
        try context.performAndWait {
            let managedCache = try ManagedCache.newUniqueInstance(in: context)
            managedCache.feed = ManagedFeedImage.images(from: feed, in: context)
            managedCache.timestamp = timestamp
            try context.save()
        }
    }
    
    public func deleteCachedFeed() throws {
        let context = self.context
        
        try context.performAndWait {
            try ManagedCache.find(in: context).map(context.delete).map(context.save)
        }
    }
}
