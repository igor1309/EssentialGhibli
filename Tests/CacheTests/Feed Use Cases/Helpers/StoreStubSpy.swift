//
//  StoreStubSpy.swift
//  
//
//  Created by Igor Malyarov on 09.10.2022.
//

import Cache
import XCTest

extension XCTestCase {
    class StoreStubSpy: FeedStore {
        private(set) var messages = [Message]()
        private var retrievalResult: Result<CachedFeed?, Error>
        private var deletionResult: Result<Void, Error>
        private var insertionResult: Result<Void, Error>
        
        init(
            retrievalResult: Result<CachedFeed?, Error>,
            deletionResult: Result<Void, Error> = .success(()),
            insertionResult: Result<Void, Error> = .success(())
        ) {
            self.retrievalResult = retrievalResult
            self.deletionResult = deletionResult
            self.insertionResult = insertionResult
        }
        
        // Retrieve
        
        func retrieve() throws -> CachedFeed? {
            messages.append(.retrieve)
            return try retrievalResult.get()
        }
        
        func stubEmptyRetrieval() {
            retrievalResult = .success(nil)
        }
        
        func stubRetrieval(with error: Error) {
            retrievalResult = .failure(error)
        }
        
        func stubRetrieval(with items: [LocalFilm], timestamp: Date = .now) {
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
        
        func insert(_ feed: [LocalFilm], timestamp: Date) throws {
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
            case insert(feed: [LocalFilm], timestamp: Date)
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
