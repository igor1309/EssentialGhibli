//
//  StoreStubSpy.swift
//  
//
//  Created by Igor Malyarov on 09.10.2022.
//

import GhibliCache
import XCTest

extension XCTestCase {
    class StoreStubSpy<Item: Equatable>: FeedStore {
        typealias CachedItems = CachedFeed<Item>
        
        private(set) var messages = [Message]()
        private var retrievalResult: Result<CachedItems, Error>
        private var deletionResult: Result<Void, Error>
        private var insertionResult: Result<Void, Error>
        
        init(
            retrievalResult: Result<CachedItems, Error>,
            deletionResult: Result<Void, Error> = .success(()),
            insertionResult: Result<Void, Error> = .success(())
        ) {
            self.retrievalResult = retrievalResult
            self.deletionResult = deletionResult
            self.insertionResult = insertionResult
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
        
        func stubDeletion(with result: Result<Void, Error>) {
            self.deletionResult = result
        }
        
        // Save
        
        func insert(_ feed: [Item], timestamp: Date) throws {
            messages.append(.insert(feed: feed, timestamp: timestamp))
            try insertionResult.get()
        }
        
        func stubInsertion(with result: Result<Void, Error>) {
            insertionResult = result
        }
        
        //
        
        enum Message: Equatable {
            case retrieve
            case deleteCachedFeed
            case insert(feed: [Item], timestamp: Date)
        }
    }
}

extension XCTestCase.StoreStubSpy.Message: CustomStringConvertible {
    var description: String {
        switch self {
        case .retrieve:
            return "retrieve"
            
        case .deleteCachedFeed:
            return "deleteCachedFeed"
            
        case let .insert(feed: feed, timestamp: date):
            return "insert(\(feed.count) items: \(feed), timestamp: \(date)"
        }
    }
}
