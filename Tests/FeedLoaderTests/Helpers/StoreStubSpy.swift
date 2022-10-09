//
//  StoreStubSpy.swift
//  
//
//  Created by Igor Malyarov on 09.10.2022.
//

import FeedLoader
import XCTest

extension XCTestCase {
    
    class StoreStubSpy<Item>: FeedStore {
        typealias CachedItems = CachedFeed<Item>
        
        private(set) var messages = [Message]()
        private var retrievalResult: Result<CachedItems, Error>
        private var deletionResult: Result<Void, Error>
        
        init(
            retrievalResult: Result<CachedItems, Error>,
            deletionResult: Result<Void, Error> = .success(())
        ) {
            self.retrievalResult = retrievalResult
            self.deletionResult = deletionResult
        }
        
        // Retrieve
        
        func retrieve() throws -> CachedItems {
            messages.append(.retrieve)
            return try retrievalResult.get()
        }
        
        func stubRetrieval(with error: Error) {
            retrievalResult = .failure(error)
        }
        
        func stubRetrieval(with items: [Item], timestamp: Date = .now) {
            retrievalResult = .success((feed: items, timestamp: timestamp))
        }
        
        // Delete
        
        func deleteCachedFeed() throws {
            messages.append(.deleteCachedFeed)
            try deletionResult.get()
        }
        
        func stubDeletion(with error: Error) {
            deletionResult = .failure(error)
        }
        
        func stubDeletion(with deletionResult: Result<Void, Error>) {
            self.deletionResult = deletionResult
        }
        
        //
        
        enum Message {
            case retrieve, deleteCachedFeed
        }
    }
}
