//
//  ImageDataCacheUseCase.swift
//  
//
//  Created by Igor Malyarov on 11.10.2022.
//

import XCTest

protocol ImageDataCacheUseCase: XCTestCase {}
    
extension ImageDataCacheUseCase where Self: XCTestCase {
    
    typealias DataResult = Result<Data?, Error>
    
    func makeSUT(
        file: StaticString = #file,
        line: UInt = #line
    ) -> (sut: FilmImageDataCache, store: StoreStub) {
        let store = StoreStub()
        let sut = FilmImageDataCache(store: store)
        
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        
        return (sut, store)
    }
    
    func expect(
        _ sut: FilmImageDataCache,
        toLoad expectedResult: DataResult,
        from url: URL,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        let retrievedResult = Result { try sut.loadImageData(from: url) }
        
        switch (expectedResult, retrievedResult) {
        case let (.success(expected), .success(retrieved)):
            XCTAssertEqual(expected, retrieved, file: file, line: line)
            
        case (.failure, .failure):
            break
            
        default:
            XCTFail("Expected \(expectedResult), got \(retrievedResult) instead.", file: file, line: line)
        }
    }
}
