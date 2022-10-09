//
//  FeedLoaderTests.swift
//  
//
//  Created by Igor Malyarov on 09.10.2022.
//

import XCTest

protocol FeedStore {
    func retrieve() throws
}

final class FeedLoader {
    private let store: FeedStore
    
    init(store: FeedStore) {
        self.store = store
    }
    
    func load() throws {
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
        
        try sut.load()
        
        XCTAssertEqual(store.messages, [.retrieve])
    }
    
    func test_load_shouldFailOnRetrievalFailure() throws {
        let (sut, store) = makeSUT()
        let anyError = AnyError()
        
        store.completeRetrieval(with: anyError)
        
        do {
            try sut.load()
            XCTFail("Expected error.")
        } catch let error as AnyError {
            XCTAssertEqual(error, anyError)
        } catch {
            XCTFail("Expected \(error) got \(error).")
        }
    }
    
    // MARK: - Helpers
    
    private func makeSUT(
        file: StaticString = #file,
        line: UInt = #line
    ) -> (sut: FeedLoader, store: StoreSpy) {
        let store = StoreSpy()
        let sut = FeedLoader(store: store)
        
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(store, file: file, line: line)
        
        return (sut, store)
    }
    
    private class StoreSpy: FeedStore {
        private(set) var messages = [Message]()
        
        private var retrievalResults = [Result<Void, Error>]()

        func retrieve() throws {
            messages.append(.retrieve)
            try retrievalResults.last?.get()
        }
        
        func completeRetrieval(with error: Error) {
            retrievalResults.append(.failure(error))
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
