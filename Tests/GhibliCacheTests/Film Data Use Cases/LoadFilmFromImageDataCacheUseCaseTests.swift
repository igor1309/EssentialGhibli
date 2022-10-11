//
//  LoadFilmFromImageDataCacheUseCaseTests.swift
//  
//
//  Created by Igor Malyarov on 11.10.2022.
//

import XCTest

final class LoadFilmFromImageDataCacheUseCaseTests: XCTestCase, ImageDataCacheUseCase {
    
    func test_init_shouldNotMessageStoreOnInit() throws {
        let (_, store) = makeSUT()
        
        XCTAssert(store.messages.isEmpty)
    }
    
    func test_loadImageDataFromURL_shouldRequestStoreRetrieval() throws {
        let (sut, store) = makeSUT()
        
        _ = try sut.loadImageData(from: .anyURL)
        
        XCTAssertEqual(store.messages, [.retrieve(.anyURL)])
    }
    
    func test_loadImageDataFromURL_shouldDeliverErrorOnRetrievalFailure() throws {
        let (sut, store) = makeSUT()
        
        store.completeRetrieval(with: .error, for: .anyURL)
        
        expect(sut, toLoad: .failure(anyError()), from: .anyURL)
    }
    
    func test_loadImageDataFromURL_shouldDeliverEmptyOnEmptyRetrieval() throws {
        let (sut, store) = makeSUT()

        store.completeRetrieval(with: .none, for: .anyURL)
        
        expect(sut, toLoad: .success(.none), from: .anyURL)
    }
    
    func test_loadImageDataFromURL_shouldDeliverImageOnDataRetrieval() throws {
        let (sut, store) = makeSUT()
        let data = "Some data here".data(using: .utf8)
        store.completeRetrieval(with: .success(data), for: .anyURL)
        
        expect(sut, toLoad: .success(data), from: .anyURL)
    }
    
    func test_loadImageDataFromURL_shouldHaveNoSideEffectsOnRetrievalFailure() throws {
        let (sut, store) = makeSUT()
        
        store.completeRetrieval(with: .error, for: .otherURL)
        do {
            _ = try sut.loadImageData(from: .anyURL)
        } catch {}
        
        XCTAssertEqual(store.messages, [.retrieve(.anyURL)])
    }
    
    func test_loadImageDataFromURL_shouldHaveNoSideEffectsOnEmptyCache() throws {
        let (sut, store) = makeSUT()

        store.completeRetrieval(with: .none, for: .otherURL)
        _ = try sut.loadImageData(from: .anyURL)
        
        XCTAssertEqual(store.messages, [.retrieve(.anyURL)])
    }
    
    func test_loadImageDataFromURL_shouldHaveNoSideEffectsOnNonEmptyCache() throws {
        let (sut, store) = makeSUT()

        store.completeRetrieval(with: .someData, for: .otherURL)
        _ = try sut.loadImageData(from: .anyURL)
        
        XCTAssertEqual(store.messages, [.retrieve(.anyURL)])
    }
}
