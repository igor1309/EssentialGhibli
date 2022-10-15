//
//  LoadFeedFromCacheUseCaseTests.swift
//  
//
//  Created by Igor Malyarov on 09.10.2022.
//

import Cache
import XCTest

final class LoadFeedFromCacheUseCaseTests: XCTestCase {
    func test_feedLoader_shouldNotMessageStoreOnInit() {
        let (_, store) = makeSUT()
        
        XCTAssert(store.messages.isEmpty)
    }
    
    func test_load_shouldRequestCacheRetrieval() throws {
        let (sut, store) = makeSUT()
        
        _ = try sut.load()
        
        XCTAssertEqual(store.messages, [.retrieve])
    }
    
    func test_load_shouldFailOnRetrievalFailure() throws {
        let (sut, store) = makeSUT()
        
        let anyError = AnyError()
        store.stubRetrieval(with: anyError)
        
        do {
            _ = try sut.load()
            XCTFail("Expected error.")
        } catch let error as AnyError {
            XCTAssertEqual(error, anyError)
        } catch {
            XCTFail("Expected \(error) got \(error).")
        }
    }
    
    func test_load_shouldDeliverNoItemsOnEmptyCache() throws {
        let (sut, store) = makeSUT()
        
        store.stubEmptyRetrieval()
        let items = try sut.load()
        
        XCTAssertEqual(items, [])
    }
    
    func test_load_shouldDeliverCachedFeedOnNonExpiredCache() throws {
        let (sut, store) = makeSUT { _, _ in true }
        
        let feed = uniqueItemFeed()
        store.stubRetrieval(with: feed.local)
        let items = try sut.load()
        
        XCTAssertEqual(items, feed.testFilms)
        XCTAssertEqual(items.count, 10)
    }
    
    func test_load_shouldDeliverNoItemsOnExpiredCache() throws {
        let (sut, store) = makeSUT { _, _ in false }
        
        let feed = uniqueItemFeed()
        store.stubRetrieval(with: feed.local)
        let items = try sut.load()
        
        XCTAssertEqual(items, [])
    }
    
    func test_load_shouldHaveNoSideEffectsOnRetrievalError() throws {
        let (sut, store) = makeSUT(retrieveError: anyError())
        
        _ = try? sut.load()
        
        XCTAssertEqual(store.messages, [.retrieve])
    }
    
    func test_load_shouldHaveNoSideEffectsOnEmptyCache() throws {
        let (sut, store) = makeSUT()
        
        store.stubEmptyRetrieval()
        _ = try sut.load()
        
        XCTAssertEqual(store.messages, [.retrieve])
    }
    
    func test_load_shouldHaveNoSideEffectsOnNonExpiredCache() throws {
        let feed = uniqueItemFeed()
        let fixedCurrentDate = Date()
        let nonExpiredTimestamp = fixedCurrentDate.minus(maxAgeInDays: FeedCachePolicy.sevenDays.maxCacheAgeInDays).adding(seconds: 1)
        let (sut, store) = makeSUT() { _, _ in true }
        
        store.stubRetrieval(with: feed.local, timestamp: nonExpiredTimestamp)
        _ = try sut.load()
        
        XCTAssertEqual(store.messages, [.retrieve])
    }
    
    func test_load_shouldHaveNoSideEffectsOnExpiredCache() throws {
        let feed = uniqueItemFeed()
        let fixedCurrentDate = Date()
        let expiredTimestamp = fixedCurrentDate.minus(maxAgeInDays: FeedCachePolicy.sevenDays.maxCacheAgeInDays).adding(seconds: -1)
        let (sut, store) = makeSUT() { _, _ in false }
        
        store.stubRetrieval(with: feed.local, timestamp: expiredTimestamp)
        _ = try sut.load()
        
        XCTAssertEqual(store.messages, [.retrieve])
    }
    
    // MARK: - Helpers
    
    typealias FilmFeedCache = FeedCache<TestFilm>

    private func makeSUT(
        validate: ((Date, Date) -> Bool)? = nil,
        retrieveFeed: CachedFeed? = (feed: [], timestamp: Date()),
        file: StaticString = #file,
        line: UInt = #line
    ) -> (
        sut: FilmFeedCache,
        store: StoreStubSpy
    ) {
        makeSUT(validate: validate, retrievalResult: .success(retrieveFeed), file: file, line: line)
    }
    
    private func makeSUT(
        validate: ((Date, Date) -> Bool)? = nil,
        retrieveError: Error,
        file: StaticString = #file,
        line: UInt = #line
    ) -> (
        sut: FilmFeedCache,
        store: StoreStubSpy
    ) {
        makeSUT(validate: validate, retrievalResult: .failure(retrieveError), file: file, line: line)
    }
    
    private func makeSUT(
        validate: ((Date, Date) -> Bool)? = nil,
        retrievalResult: Result<CachedFeed?, Error>,
        file: StaticString = #file,
        line: UInt = #line
    ) -> (
        sut: FilmFeedCache,
        store: StoreStubSpy
    ) {
        let store = StoreStubSpy(retrievalResult: retrievalResult)
        
        let validate = validate ?? FeedCachePolicy.sevenDays.validate
        
        let sut = FeedCache(store: store, toLocal: toLocal, fromLocal: fromLocal, validate: validate)
        
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(store, file: file, line: line)
        
        return (sut, store)
    }
}
