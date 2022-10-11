//
//  FilmImageDataCacheTests.swift
//  
//
//  Created by Igor Malyarov on 11.10.2022.
//

import XCTest

protocol FilmDataStore {
    
}

final class FilmImageDataCache {
    private let store: FilmDataStore
    
    init(store: FilmDataStore) {
        self.store = store
    }
}

final class FilmImageDataCacheTests: XCTestCase {
    
    func test_init_shouldNotMessageStoreOnInit() throws {
        let (_, store) = makeSUT()
        
        XCTAssert(store.messages.isEmpty)
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
        private(set) var messages = [Message]()
        
        enum Message {
            
        }
    }
}
