//
//  CacheFeedUseCaseTests.swift
//  
//
//  Created by Igor Malyarov on 09.10.2022.
//

import GhibliCache
import XCTest

final class CacheFeedUseCaseTests: XCTestCase {
    
    func test_init_shouldNotMessageStoreOnInit() throws {
        let (_, store) = makeSUT()
        
        XCTAssert(store.messages.isEmpty)
    }
    
    func test_save_shouldRequestCacheDeletion() throws {
        let feed = uniqueItemFeed()
        let timestamp = Date.distantPast
        let (sut, store) = makeSUT()
        
        try sut.save(feed: feed.testItems, timestamp: timestamp)
        
        XCTAssertEqual(store.messages, [.deleteCachedFeed, .insert(feed: feed.local, timestamp: timestamp)])
    }
    
    func test_save_shouldNotRequestCacheInsertionOnDeletionError() throws {
        let feed = uniqueItemFeed()
        let (sut, store) = makeSUT()
        
        store.stubDeletion(with: anyError())
        try? sut.save(feed: feed.testItems, timestamp: .now)
        
        XCTAssertEqual(store.messages, [.deleteCachedFeed])
    }
    
    func test_save_shouldRequestNewCacheInsertionWithTimestampOnSuccessfulDeletion() throws {
        let feed = uniqueItemFeed()
        let timestamp = Date.distantPast
        let (sut, store) = makeSUT()
        
        store.stubRetrieval(with: feed.local, timestamp: timestamp)
        try sut.save(feed: feed.testItems, timestamp: timestamp)
        
        XCTAssertEqual(store.messages, [.deleteCachedFeed, .insert(feed: feed.local, timestamp: timestamp)])
    }
    
    func test_save_shouldFailOnDeletionError() throws {
        let (sut, store) = makeSUT()
        
        store.stubDeletion(with: anyError())
        
        do {
            try sut.save(feed: [], timestamp: .now)
            XCTFail("Expected error.")
        } catch let error as AnyError {
            XCTAssertEqual(error, AnyError())
        } catch {
            XCTFail("Expected AnyError, got \(error).")
        }
    }
    
    func test_save_shouldFailOnInsertionError() throws {
        let (sut, store) = makeSUT()
        
        store.stubInsertion(with: .failure(anyError()))
        
        do {
            try sut.save(feed: [], timestamp: .now)
            XCTFail("Expected error.")
        } catch let error as AnyError {
            XCTAssertEqual(error, AnyError())
        } catch {
            XCTFail("Expected AnyError, got \(error).")
        }
    }
    
    func test_save_shouldSucceedOnSuccessfulCacheInsertion() throws {
        let (sut, _) = makeSUT()
        
        XCTAssertNoThrow(try sut.save(feed: [], timestamp: .now))
    }
    
    // MARK: - Helpers
    
    private func makeSUT(
        validate: ((Date, Date) -> Bool)? = nil,
        retrieveFeed: CachedItems? = (feed: [], timestamp: Date()),
        file: StaticString = #file,
        line: UInt = #line
    ) -> (
        sut: LocalFeedLoader<TestItem, StoreStubSpy<LocalItem>>,
        store: StoreStubSpy<LocalItem>
    ) {
        makeSUT(validate: validate, retrievalResult: .success(retrieveFeed), file: file, line: line)
    }
    
    private func makeSUT(
        validate: ((Date, Date) -> Bool)? = nil,
        retrieveError: Error,
        file: StaticString = #file,
        line: UInt = #line
    ) -> (
        sut: LocalFeedLoader<TestItem, StoreStubSpy<LocalItem>>,
        store: StoreStubSpy<LocalItem>
    ) {
        makeSUT(validate: validate, retrievalResult: .failure(retrieveError), file: file, line: line)
    }
    
    private func makeSUT(
        validate: ((Date, Date) -> Bool)? = nil,
        retrievalResult: Result<CachedItems?, Error>,
        file: StaticString = #file,
        line: UInt = #line
    ) -> (
        sut: LocalFeedLoader<TestItem, StoreStubSpy<LocalItem>>,
        store: StoreStubSpy<LocalItem>
    ) {
        let store = StoreStubSpy<LocalItem>(retrievalResult: retrievalResult)
        
        let validate = validate ?? FeedCachePolicy.sevenDays.validate
        
        let sut = LocalFeedLoader(store: store, toLocal: toLocal, fromLocal: fromLocal, validate: validate)
        
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(store, file: file, line: line)
        
        return (sut, store)
    }
}
