//
//  ImageDataCacheUseCase.swift
//  
//
//  Created by Igor Malyarov on 11.10.2022.
//

import GhibliCache
import XCTest

protocol ImageDataCacheUseCase: XCTestCase {}
    
extension ImageDataCacheUseCase where Self: XCTestCase {
    
    typealias DataResult = Result<Data?, Error>
    typealias LoadError = FilmImageDataCache.LoadError
    
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
        let loadedResult = Result { try sut.loadImageData(from: url) }
        
        switch (expectedResult, loadedResult) {
        case let (.success(expected), .success(loaded)):
            XCTAssertEqual(expected, loaded, file: file, line: line)
            
        case let (.failure(expected), .failure(loaded)):
            switch (expected, loaded) {
            case (LoadError.failed, LoadError.failed),
                (LoadError.notFound, LoadError.notFound):
                break
                
            default:
                XCTFail("Expected \(expected.localizedDescription), got \(loaded.localizedDescription)", file: file, line: line)
            }
            
        default:
            XCTFail("Expected \(expectedResult), got \(loadedResult) instead.", file: file, line: line)
        }
    }
}
