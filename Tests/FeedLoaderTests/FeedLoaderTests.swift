//
//  FeedLoaderTests.swift
//  
//
//  Created by Igor Malyarov on 09.10.2022.
//

import XCTest

protocol FeedStore {
    func retrieve()
}

final class FeedLoader {
    private let store: FeedStore
    
    init(store: FeedStore) {
        self.store = store
    }
    
    func load() {
        store.retrieve()
    }
}

final class FeedLoaderTests: XCTestCase {
    func test_feedLoader_shouldNotMessageStoreOnInit() {
        let (_, store) = makeSUT()
        
        XCTAssert(store.messages.isEmpty)
    }
    
    func test_load_shouldRequestCacheRetrieval() {
        let (sut, store) = makeSUT()
        
        sut.load()
        
        XCTAssertEqual(store.messages, [.retrieve])
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

        func retrieve() {
            messages.append(.retrieve)
        }
        
        enum Message {
            case retrieve
        }
    }
}
