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
        
        store.completeRetrieval(with: anyError)
        
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
        store.completeRetrieval(with: [])
        let items = try sut.load()
        
        XCTAssertEqual(items, [])
    }
    
    
    // MARK: - Helpers
    
    struct TestItem: Equatable {}
    
    private func makeSUT(
        file: StaticString = #file,
        line: UInt = #line
    ) -> (sut: FeedLoader<TestItem, StoreSpy<TestItem>>, store: StoreSpy<TestItem>) {
        let store = StoreSpy<TestItem>()
        let sut = FeedLoader<TestItem, StoreSpy>(store: store)
        
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(store, file: file, line: line)
        
        return (sut, store)
    }
    
    private class StoreSpy<Item>: FeedStore {
        private(set) var messages = [Message]()
        
        private var retrievalResults = [Result<[Item], Error>]()

        func retrieve() throws -> [Item] {
            messages.append(.retrieve)
            #warning("I do not like the logic here! spy should just collect messages and reply with stubbed completions")
            return try retrievalResults.last?.get() ?? []
        }
        
        func completeRetrieval(with error: Error) {
            retrievalResults.append(.failure(error))
        }
        
        func completeRetrieval(with items: [Item]) {
            retrievalResults.append(.success(items))
        }
        
        enum Message {
            case retrieve
        }
    }
}

private func anyError() -> Error {
    AnyError()
}

private struct AnyError: Error, Equatable {}
