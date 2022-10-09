//
//  FeedLoaderTests.swift
//  
//
//  Created by Igor Malyarov on 09.10.2022.
//

import FeedLoader
import XCTest

typealias CachedFeed<Item> = (feed: [Item], timestamp: Date)

protocol FeedStore {
    associatedtype Item
    
    func retrieve() throws -> CachedFeed<Item>
}

final class FeedLoader<Item, Store>
where Store: FeedStore,
      Store.Item == Item {
    
    typealias Validate = (Date, Date) -> Bool
    
    private let store: Store
    private let validate: Validate
    
    init(store: Store, validate: @escaping Validate) {
        self.store = store
        self.validate = validate
    }
    
    func load() throws -> [Item] {
        let cached = try store.retrieve()

        return validate(.now, cached.timestamp) ? cached.feed : []
    }
}

final class FeedLoaderTests: XCTestCase {
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
        
        store.stubRetrieval(with: [])
        let items = try sut.load()
        
        XCTAssertEqual(items, [])
    }
    
    func test_load_shouldDeliverCachedItemsOnNonExpiredCache() throws {
        let (sut, store) = makeSUT { _, _ in true }
        
        let uniqueItems = uniqueItemFeed()
        store.stubRetrieval(with: uniqueItems)
        let items = try sut.load()
        
        XCTAssertEqual(items, uniqueItems)
        XCTAssertEqual(items.count, 10)
    }
    
    func test_load_shouldDeliverNoItemsOnExpiredCache() throws {
        let (sut, store) = makeSUT { _, _ in false }
        
        let uniqueItems = uniqueItemFeed()
        store.stubRetrieval(with: uniqueItems)
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

        _ = try sut.load()

        XCTAssertEqual(store.messages, [.retrieve])
    }

    func test_load_shouldHaveNoSideEffectsOnNonExpiredCache() throws {
        let feed = uniqueItemFeed()
        let fixedCurrentDate = Date()
        let nonExpiredTimestamp = fixedCurrentDate.minus(maxAgeInDays: FeedCachePolicy.sevenDays.maxCacheAgeInDays).adding(seconds: 1)
        let (sut, store) = makeSUT() { _, _ in true }

        store.stubRetrieval(with: feed, timestamp: nonExpiredTimestamp)
        _ = try sut.load()

        XCTAssertEqual(store.messages, [.retrieve])
    }

    func test_load_shouldHaveNoSideEffectsOnExpiredCache() throws {
        let feed = uniqueItemFeed()
        let fixedCurrentDate = Date()
        let expiredTimestamp = fixedCurrentDate.minus(maxAgeInDays: FeedCachePolicy.sevenDays.maxCacheAgeInDays).adding(seconds: -1)
        let (sut, store) = makeSUT() { _, _ in false }

        store.stubRetrieval(with: feed, timestamp: expiredTimestamp)
        _ = try sut.load()

        XCTAssertEqual(store.messages, [.retrieve])
    }

    // MARK: - Helpers
    
    typealias CachedItems = CachedFeed<TestItem>
    
    struct TestItem: Equatable {
        let id: UUID
    }
    
    private func makeSUT(
        validate: @escaping FeedLoader.Validate = FeedCachePolicy.sevenDays.validate,
        retrieveFeed: CachedItems = (feed: [], timestamp: Date()),
        file: StaticString = #file,
        line: UInt = #line
    ) -> (
        sut: FeedLoader<TestItem, StoreStubSpy<TestItem>>,
        store: StoreStubSpy<TestItem>
    ) {
        makeSUT(validate: validate, retrievalResult: .success(retrieveFeed), file: file, line: line)
    }
    
    private func makeSUT(
        validate: @escaping FeedLoader.Validate = FeedCachePolicy.sevenDays.validate,
        retrieveError: Error,
        file: StaticString = #file,
        line: UInt = #line
    ) -> (
        sut: FeedLoader<TestItem, StoreStubSpy<TestItem>>,
        store: StoreStubSpy<TestItem>
    ) {
        makeSUT(validate: validate, retrievalResult: .failure(retrieveError), file: file, line: line)
    }
    
    private func makeSUT(
        validate: @escaping FeedLoader.Validate,
        retrievalResult: Result<CachedItems, Error>,
        file: StaticString = #file,
        line: UInt = #line
    ) -> (
        sut: FeedLoader<TestItem, StoreStubSpy<TestItem>>,
        store: StoreStubSpy<TestItem>
    ) {
        let store = StoreStubSpy<TestItem>(retrievalResult: retrievalResult)
        let sut = FeedLoader(store: store, validate: validate)
        
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(store, file: file, line: line)
        
        return (sut, store)
    }
    
    private func uniqueItemFeed() -> [TestItem] {
        (0...9).map { _ in TestItem(id: .init()) }
    }
    
    private class StoreStubSpy<Item>: FeedStore {
        typealias CachedItems = CachedFeed<Item>
        
        private(set) var messages = [Message]()
        private var retrievalResult: Result<CachedItems, Error>
        
        init(retrievalResult: Result<CachedItems, Error>) {
            self.retrievalResult = retrievalResult
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
        
        //
        
        enum Message {
            case retrieve
        }
    }
}

private func anyError() -> Error {
    AnyError()
}

private struct AnyError: Error, Equatable {}
