//
//  CoreDataFeedStore+FilmImageDataStore.swift
//  
//
//  Created by Igor Malyarov on 12.10.2022.
//

import GhibliCache
import CoreData

extension CoreDataFeedStore: FilmImageDataStore {
    
    public func retrieve(dataForURL url: URL) throws -> Data? {
        try performSync { context in
            Result {
                try ManagedFilmImage.data(with: url, in: context)
            }
        }
    }
    
    public func insert(_ data: Data, for url: URL) throws {
        try performSync { context in
            Result {
                try ManagedFilmImage.first(with: url, in: context)
                    .map { $0.data = data }
                    .map(context.save)
            }
        }
    }
}
