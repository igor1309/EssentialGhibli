//
//  NullStore.swift
//  EssentialGhibli
//
//  Created by Igor Malyarov on 15.10.2022.
//

import Cache
import Foundation

final class NullStore<Item> {}

extension NullStore: FeedStore {
    func deleteCachedFeed() throws {}
    func insert(_ feed: [LocalFilm], timestamp: Date) throws {}
    func retrieve() throws -> CachedFeed? { .none }
}

extension NullStore: FilmImageDataStore {
    func retrieve(dataForURL url: URL) throws -> Data? { .none }    
    func insert(_ data: Data, for url: URL) throws {}
}
