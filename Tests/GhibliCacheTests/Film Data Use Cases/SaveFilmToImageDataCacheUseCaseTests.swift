//
//  SaveFilmToImageDataCacheUseCaseTests.swift
//  
//
//  Created by Igor Malyarov on 11.10.2022.
//

import XCTest

final class SaveFilmToImageDataCacheUseCaseTests: XCTestCase, ImageDataCacheUseCase {
    
    func test_init_shouldNotMessageStoreOnInit() throws {
        let (_, store) = makeSUT()
        
        XCTAssert(store.messages.isEmpty)
    }
    
    func test_saveImageDataForURL_shouldRequestImageDataInsertionForURL() throws {
        let (sut, store) = makeSUT()
        let (image, data) = imageData()
        
        try sut.saveImageData(image, for: .anyURL)
        
        XCTAssertEqual(store.messages, [.save(data, .anyURL)])
    }
    
    func test_saveImageDataFromURL_shouldDeliverErrorOnStoreInsertionError() throws {
        let (sut, store) = makeSUT()
        let image = imageData().image
        store.stubInsert(for: .anyURL, with: .failure(anyError()))
        
        XCTAssertThrowsError(try sut.saveImageData(image, for: .anyURL))
    }
    
}
