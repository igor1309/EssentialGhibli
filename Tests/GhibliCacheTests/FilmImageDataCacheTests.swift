//
//  FilmImageDataCacheTests.swift
//  
//
//  Created by Igor Malyarov on 11.10.2022.
//

import XCTest

protocol FilmDataStore {
    func retrieve() throws
}

final class FilmImageDataCache {
    private let store: FilmDataStore
    
    init(store: FilmDataStore) {
        self.store = store
    }
    
    func load() throws {
        try store.retrieve()
    }
}

final class FilmImageDataCacheTests: XCTestCase {
    
    func test_init_shouldNotMessageStoreOnInit() throws {
        let (_, store) = makeSUT()
        
        XCTAssert(store.messages.isEmpty)
    }

    func test_load_shouldRequestStoreRetrieval() throws {
        let (sut, store) = makeSUT()
        
        try sut.load()
        
        XCTAssertEqual(store.messages, [.retrieve])
    }
    
    func test_load_shouldDeliverErrorOnRetrievalFailure() throws {
        let (sut, store) = makeSUT()
        store.completeRetrieval(with: .failure(anyError()))

        do {
            try sut.load()
            XCTFail("Expected error")
        } catch let error as AnyError {
            XCTAssertEqual(error, AnyError())
        } catch {
            XCTFail("Expected AnyError, got \(error.localizedDescription)")
        }
    }
    
    // MARK: - Helpers
    
    private func makeSUT(
        file: StaticString = #file,
        line: UInt = #line
    ) -> (sut: FilmImageDataCache, store: StoreStub) {
        let store = StoreStub()
        let sut = FilmImageDataCache(store: store)
        
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        
        return (sut, store)
    }
    
    private final class StoreStub: FilmDataStore {
        typealias RetrievalResult = Result<(), Error>
        
        private var retrievalResult: RetrievalResult?
        private(set) var messages = [Message]()
        
        func completeRetrieval(with result: RetrievalResult) {
            self.retrievalResult = result
        }
        
        func retrieve() throws {
            messages.append(.retrieve)
            try retrievalResult?.get()
        }
        
        enum Message {
            case retrieve
        }
    }
}
