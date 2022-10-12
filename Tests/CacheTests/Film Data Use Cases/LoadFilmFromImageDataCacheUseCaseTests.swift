//
//  LoadFilmFromImageDataCacheUseCaseTests.swift
//  
//
//  Created by Igor Malyarov on 11.10.2022.
//

import Cache
import XCTest

final class LoadFilmFromImageDataCacheUseCaseTests: XCTestCase, ImageDataCacheUseCase {
    
    func test_init_shouldNotMessageStoreOnInit() throws {
        let (_, store) = makeSUT()
        
        XCTAssert(store.messages.isEmpty)
    }
    
    func test_loadImageDataFromURL_shouldRequestStoreRetrievalForURL() throws {
        let (sut, store) = makeSUT()
        store.completeRetrieval(with: .someData, for: .anyURL)
        
        _ = try sut.loadImageData(from: .anyURL)
        
        XCTAssertEqual(store.messages, [.retrieve(.anyURL)])
    }
    
    func test_loadImageDataFromURL_shouldDeliverLoadErrorOnRetrievalFailure() throws {
        let (sut, store) = makeSUT()
        
        store.completeRetrieval(with: .error, for: .anyURL)
        
        expect(sut, toLoad: .failure(LoadError.failed), from: .anyURL)
    }
    
    func test_loadImageDataFromURL_shouldDeliverNotFoundErrorOnEmptyRetrieval() throws {
        let (sut, store) = makeSUT()

        store.completeRetrieval(with: .none, for: .anyURL)
        
        expect(sut, toLoad: .failure(LoadError.notFound), from: .anyURL)
    }
    
    func test_loadImageDataFromURL_shouldDeliverDataOnDataRetrieval() throws {
        let (sut, store) = makeSUT()
        store.completeRetrieval(with: .someData, for: .anyURL)
        
        expect(sut, toLoad: .someData, from: .anyURL)
    }
    
    func test_loadImageDataFromURL_shouldHaveNoSideEffectsOnRetrievalFailure() throws {
        let (sut, store) = makeSUT()
        
        store.completeRetrieval(with: .error, for: .otherURL)
        _ = try? sut.loadImageData(from: .anyURL)
        
        XCTAssertEqual(store.messages, [.retrieve(.anyURL)])
    }
    
    func test_loadImageDataFromURL_shouldHaveNoSideEffectsOnEmptyCache() throws {
        let (sut, store) = makeSUT()

        store.completeRetrieval(with: .none, for: .otherURL)
        _ = try? sut.loadImageData(from: .anyURL)
        
        XCTAssertEqual(store.messages, [.retrieve(.anyURL)])
    }
    
    func test_loadImageDataFromURL_shouldHaveNoSideEffectsOnNonEmptyCache() throws {
        let (sut, store) = makeSUT()

        store.completeRetrieval(with: .someData, for: .anyURL)
        _ = try sut.loadImageData(from: .anyURL)
        
        XCTAssertEqual(store.messages, [.retrieve(.anyURL)])
    }
}
