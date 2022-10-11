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
    
    func test_saveImageDataForURL_requestsImageDataInsertionForURL() throws {
        let (sut, store) = makeSUT()
        let (image, data) = imageData()
        
        try sut.saveImageData(image, for: .anyURL)
        
        XCTAssertEqual(store.messages, [.save(data, .anyURL)])
    }
    
}
