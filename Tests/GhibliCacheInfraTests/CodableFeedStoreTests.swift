//
//  CodableFeedStoreTests.swift
//  
//
//  Created by Igor Malyarov on 10.10.2022.
//

import GhibliCache
import GhibliCacheInfra
import XCTest

struct CodableFilm: Equatable {
    
}

final class CodableFeedStore {
    
    func retrieve() throws -> CachedFeed<CodableFilm>? {
        nil
    }
}

final class CodableFeedStoreTests: XCTestCase {
    
    func test_shouldDeliverEmptyCacheOnEmptyCache() throws {
        let sut = makeSUT()

        let feed = try sut.retrieve()
        
        XCTAssertNil(feed)
    }
    
    // MRK: - Helpers
    
    private func makeSUT(
        file: StaticString = #file,
        line: UInt = #line
    ) -> CodableFeedStore {
        let sut = CodableFeedStore()
        
        trackForMemoryLeaks(sut, file: file, line: line)
        
        return sut
    }
}
