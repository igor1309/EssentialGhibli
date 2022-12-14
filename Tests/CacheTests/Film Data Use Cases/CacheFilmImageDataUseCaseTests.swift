//
//  CacheFilmImageDataUseCaseTests.swift
//  
//
//  Created by Igor Malyarov on 11.10.2022.
//

import Cache
import XCTest

final class CacheFilmImageDataUseCaseTests: XCTestCase, ImageDataCacheUseCase {
    
    func test_init_shouldNotMessageStoreOnInit() throws {
        let (_, store) = makeSUT()
        
        XCTAssert(store.messages.isEmpty)
    }
    
    func test_saveImageDataForURL_shouldRequestImageDataInsertionForURL() throws {
        let (sut, store) = makeSUT()
        let data = Data.anyData
        
        try sut.saveImageData(data, for: .anyURL)
        
        XCTAssertEqual(store.messages, [.save(data, .anyURL)])
    }
    
    func test_saveImageDataFromURL_shouldDeliverSaveErrorOnStoreInsertionError() throws {
        let (sut, store) = makeSUT()
        store.stubInsert(for: .anyURL, with: .error)
        
        do {
            try sut.saveImageData(.anyData, for: .anyURL)
            XCTFail("Expected error.")
        } catch let error as FilmImageDataCache.SaveError {
            XCTAssertEqual(error, .failed)
        } catch {
            XCTFail("Expected \"SaveError\", got \(error.localizedDescription)")
        }
    }
    
    func test_saveImageDataFromURL_shouldSucceedOnSuccessfulStoreInsertion() throws {
        let (sut, store) = makeSUT()
        let data = Data.anyData
        store.stubInsert(for: .anyURL, with: .success(data))
        
        XCTAssertNoThrow(try sut.saveImageData(data, for: .anyURL))
    }
}
