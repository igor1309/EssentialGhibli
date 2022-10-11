//
//  CacheFilmImageDataUseCaseTests.swift
//  
//
//  Created by Igor Malyarov on 11.10.2022.
//

import XCTest

final class CacheFilmImageDataUseCaseTests: XCTestCase, ImageDataCacheUseCase {
    
    func test_init_shouldNotMessageStoreOnInit() throws {
        let (_, store) = makeSUT()
        
        XCTAssert(store.messages.isEmpty)
    }
    
    func test_saveImageDataForURL_shouldRequestImageDataInsertionForURL() throws {
        let (sut, store) = makeSUT()
        let data = "Some data here".data(using: .utf8)!
        
        try sut.saveImageData(data, for: .anyURL)
        
        XCTAssertEqual(store.messages, [.save(data, .anyURL)])
    }
    
    func test_saveImageDataFromURL_shouldDeliverErrorOnStoreInsertionError() throws {
        let (sut, store) = makeSUT()
        let data = "Some data here".data(using: .utf8)!
        store.stubInsert(for: .anyURL, with: .failure(anyError()))
        
        XCTAssertThrowsError(try sut.saveImageData(data, for: .anyURL))
    }
    
    func test_saveImageDataFromURL_succeedsOnSuccessfulStoreInsertion() throws {
        let (sut, store) = makeSUT()
        let data = "Some data here".data(using: .utf8)!
        store.stubInsert(for: .anyURL, with: .success(data))
        
        XCTAssertNoThrow(try sut.saveImageData(data, for: .anyURL))
    }
}
