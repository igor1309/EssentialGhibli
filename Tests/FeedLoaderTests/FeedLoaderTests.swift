//
//  FeedLoaderTests.swift
//  
//
//  Created by Igor Malyarov on 09.10.2022.
//

import XCTest

protocol FeedStore {
    associatedtype Item
    
    func retrieve() throws -> [Item]
}

final class FeedLoader<Item, Store>
where Store: FeedStore,
      Store.Item == Item {
    
    private let store: Store
    
    init(store: Store) {
        self.store = store
    }
    
    func load() throws -> [Item]{
        try store.retrieve()
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
        let (sut, store) = makeSUT()
        
        let uniqueItems = makeItems()
        store.stubRetrieval(with: uniqueItems)
        let items = try sut.load()
        
        XCTAssertEqual(items, uniqueItems)
        XCTAssertEqual(items.count, 10)
    }
    
    // MARK: - Helpers
    
    struct TestItem: Equatable {
        let id: UUID
    }
    
    private func makeSUT(
        retrieveItems: [TestItem] = [],
        file: StaticString = #file,
        line: UInt = #line
    ) -> (
        sut: FeedLoader<TestItem, StoreStubSpy<TestItem>>,
        store: StoreStubSpy<TestItem>
    ) {
        makeSUT(retrievalResult: .success(retrieveItems), file: file, line: line)
    }
    
    private func makeSUT(
        retrieveError: Error,
        file: StaticString = #file,
        line: UInt = #line
    ) -> (
        sut: FeedLoader<TestItem, StoreStubSpy<TestItem>>,
        store: StoreStubSpy<TestItem>
    ) {
        makeSUT(retrievalResult: .failure(retrieveError), file: file, line: line)
    }
    
    private func makeSUT(
        retrievalResult: Result<[TestItem], Error>,
        file: StaticString = #file,
        line: UInt = #line
    ) -> (
        sut: FeedLoader<TestItem, StoreStubSpy<TestItem>>,
        store: StoreStubSpy<TestItem>
    ) {
        let store = StoreStubSpy<TestItem>(retrievalResult: retrievalResult)
        let sut = FeedLoader(store: store)
        
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(store, file: file, line: line)
        
        return (sut, store)
    }
    
    private func makeItems() -> [TestItem] {
        (0...9).map { _ in TestItem(id: .init()) }
    }
    
    private class StoreStubSpy<Item>: FeedStore {
        private(set) var messages = [Message]()
        private var retrievalResult: Result<[Item], Error>
        
        init(retrievalResult: Result<[Item], Error>) {
            self.retrievalResult = retrievalResult
        }
        
        // Retrieve
        
        func retrieve() throws -> [Item] {
            messages.append(.retrieve)
            return try retrievalResult.get()
        }
        
        func stubRetrieval(with error: Error) {
            retrievalResult = .failure(error)
        }
        
        func stubRetrieval(with items: [Item]) {
            retrievalResult = .success(items)
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
