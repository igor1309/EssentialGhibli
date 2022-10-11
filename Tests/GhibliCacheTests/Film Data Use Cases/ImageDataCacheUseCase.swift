//
//  ImageDataCacheUseCase.swift
//  
//
//  Created by Igor Malyarov on 11.10.2022.
//

import XCTest

protocol ImageDataCacheUseCase: XCTestCase {}
    
extension ImageDataCacheUseCase where Self: XCTestCase {
    
    typealias Image = String
    typealias ImageResult = Result<Image?, Error>
    typealias DataCache = FilmImageDataCache<Image>
    
    func makeSUT(
        file: StaticString = #file,
        line: UInt = #line
    ) -> (sut: DataCache, store: StoreStub) {
        let store = StoreStub()
        let sut = DataCache(
            store: store,
            makeImage: { .init(data: $0, encoding: .utf8) },
            makeData: { $0.data(using: .utf8) }
        )
        
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        
        return (sut, store)
    }
    
    func expect(
        _ sut: DataCache,
        toLoad expectedResult: ImageResult,
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
