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
    
    func test_load_shouldRequestStoreRetrieval() throws {
        let (sut, store) = makeSUT()
        
        _ = try sut.load()
        
        XCTAssertEqual(store.messages, [.retrieve])
    }
    
    func test_load_shouldDeliverErrorOnRetrievalFailure() throws {
        let (sut, store) = makeSUT()
        store.completeRetrieval(with: .error)
        
        expect(sut, toLoad: .failure(anyError()))
    }
    
    func test_load_shouldDeliverEmptyOnEmptyRetrieval() throws {
        let (sut, store) = makeSUT()
        store.completeRetrieval(with: .none)
        
        expect(sut, toLoad: .success(.none))
    }
    
    func test_load_shouldDeliverImageOnDataRetrieval() throws {
        let (sut, store) = makeSUT()
        let expectedImage = "Some data here"
        let imageData = expectedImage.data(using: .utf8)
        store.completeRetrieval(with: .success(imageData))
        
        expect(sut, toLoad: .success(expectedImage))
    }
    
    func test_load_shouldHaveNoSideEffectsOnRetrievalFailure() throws {
        let (sut, store) = makeSUT()
        
        store.completeRetrieval(with: .error)
        do {
            _ = try sut.load()
        } catch {}
        
        XCTAssertEqual(store.messages, [.retrieve])
    }
    
    func test_load_shouldHaveNoSideEffectsOnEmptyCache() throws {
        let (sut, store) = makeSUT()
        
        store.completeRetrieval(with: .none)
        _ = try sut.load()
        
        XCTAssertEqual(store.messages, [.retrieve])
    }
    
    func test_load_shouldHaveNoSideEffectsOnNonEmptyCache() throws {
        let (sut, store) = makeSUT()
        
        store.completeRetrieval(with: .someData)
        _ = try sut.load()
        
        XCTAssertEqual(store.messages, [.retrieve])
    }
}
