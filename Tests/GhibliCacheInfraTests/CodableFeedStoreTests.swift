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
        
        XCTAssertNil(feed, "Expected retrieving from empty cache to deliver empty result.")
    }
    
    func test_shouldHaveNoSideEffectsOnEmptyCache() throws {
        let sut = makeSUT()

        let feed = try sut.retrieve()
        XCTAssertNil(feed)
        
        let feed2 = try sut.retrieve()
        XCTAssertNil(feed2, "Expected retrieving twice from empty cache to deliver same empty result.")
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
