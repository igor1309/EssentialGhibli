//
//  ValidateFeedCacheUseCaseTests.swift
//  
//
//  Created by Igor Malyarov on 09.10.2022.
//

import FeedLoader
import XCTest

final class ValidateFeedCacheUseCaseTests: XCTestCase {
    
    func test_init_shouldNotMessageStoreOnInit() throws {
        let (_, store) = makeSUT()
        
        XCTAssert(store.messages.isEmpty)
    }
    
    func test_validateCache_shouldDeleteCacheOnRetrievalError() throws {
        let (sut, store) = makeSUT(retrieveError: anyError())
        
        try? sut.validateCache()
        
        XCTAssertEqual(store.messages, [.retrieve, .deleteCachedFeed])
    }
    
    func test_validateCache_shouldNotDeleteCacheOnEmptyCache() throws {
        let (sut, store) = makeSUT()
        
        try sut.validateCache()
        
        XCTAssertEqual(store.messages, [.retrieve])
    }
    
    func test_validateCache_shouldNotDeleteNonExpiredCache() throws {
        let (sut, store) = makeSUT() { _, _ in true }
        
        try sut.validateCache()
        
        XCTAssertEqual(store.messages, [.retrieve])
    }
    
    func test_validateCache_shouldDeleteExpiredCache() throws {
        let (sut, store) = makeSUT() { _, _ in false }
        
        try sut.validateCache()
        
        XCTAssertEqual(store.messages, [.retrieve, .deleteCachedFeed])
    }
    
    func test_validateCache_shouldFailOnDeletionErrorOfFailedRetrieval() throws {
        let (sut, store) = makeSUT() { _, _ in false }
        
        store.stubDeletion(with: anyError())
        do {
            try sut.validateCache()
            XCTFail("Expected error.")
        } catch let error as AnyError {
            XCTAssertEqual(error, AnyError())
        } catch {
            XCTFail("Expected \"AnyError\", got \(error).")
        }
    }
    
    func test_validateCache_shouldSucceedOnSuccessfulDeletionOfFailedRetrieval() throws {
        let (sut, store) = makeSUT() { _, _ in false }
        
        store.stubDeletion(with: .success(()))
        try sut.validateCache()
        
        XCTAssertEqual(store.messages, [.retrieve, .deleteCachedFeed])
    }
    
    func test_validateCache_shouldSucceedOnEmptyCache() {
        let (sut, _) = makeSUT()
        
        XCTAssertNoThrow(try sut.validateCache())
    }
    
    func test_validateCache_shouldSucceedOnNonExpiredCache() {
        let (sut, _) = makeSUT()
        
        XCTAssertNoThrow(try sut.validateCache())
    }
    
    func test_validateCache_shouldFailOnDeletionErrorOfExpiredCache() throws {
        let (sut, store) = makeSUT() { _, _ in false }
        
        store.stubDeletion(with: anyError())
        
        do {
            try sut.validateCache()
            XCTFail("Expected error.")
        } catch let error as AnyError {
            XCTAssertEqual(error, AnyError())
        } catch {
            XCTFail("Expected \"AnyError\", got \(error).")
        }
    }
    
    func test_validateCache_shouldSucceedOnSuccessfulDeletionOfExpiredCache() throws {
        let (sut, store) = makeSUT() { _, _ in false }
        
        store.stubDeletion(with: .success(()))
        
        XCTAssertNoThrow(try sut.validateCache())
    }
    
    // MARK: - Helpers
    
    private func makeSUT(
        validate: ((Date, Date) -> Bool)? = nil,
        retrieveFeed: CachedItems = (feed: [], timestamp: Date()),
        file: StaticString = #file,
        line: UInt = #line
    ) -> (
        sut: FeedLoader<TestItem, StoreStubSpy<CachedItem>>,
        store: StoreStubSpy<CachedItem>
    ) {
        makeSUT(validate: validate, retrievalResult: .success(retrieveFeed), file: file, line: line)
    }
    
    private func makeSUT(
        validate: ((Date, Date) -> Bool)? = nil,
        retrieveError: Error,
        file: StaticString = #file,
        line: UInt = #line
    ) -> (
        sut: FeedLoader<TestItem, StoreStubSpy<CachedItem>>,
        store: StoreStubSpy<CachedItem>
    ) {
        makeSUT(validate: validate, retrievalResult: .failure(retrieveError), file: file, line: line)
    }
    
    private func makeSUT(
        validate: ((Date, Date) -> Bool)? = nil,
        retrievalResult: Result<CachedItems, Error>,
        file: StaticString = #file,
        line: UInt = #line
    ) -> (
        sut: FeedLoader<TestItem, StoreStubSpy<CachedItem>>,
        store: StoreStubSpy<CachedItem>
    ) {
        let store = StoreStubSpy(retrievalResult: retrievalResult)
        
        let validate = validate ?? FeedCachePolicy.sevenDays.validate
        
        let sut = FeedLoader(store: store, toCached: toCached, fromCached: fromCached, validate: validate)
        
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(store, file: file, line: line)
        
        return (sut, store)
    }
}
