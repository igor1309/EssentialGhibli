//
//  XCTestCase+FailableDeleteFeedStoreSpecs.swift
//  
//
//  Created by Igor Malyarov on 11.10.2022.
//

import GhibliCache
import GhibliCacheInfra
import XCTest

extension FailableDeleteFeedStoreSpecs where Self: XCTestCase {
    func assertThatDeleteDeliversErrorOnDeletionError(on sut: any FeedStore<LocalFilm>, file: StaticString = #file, line: UInt = #line) {
        
        XCTFail("Unimplemented")
//        let deletionError = deleteCache(from: sut)
//
//        XCTAssertNotNil(deletionError, "Expected cache deletion to fail", file: file, line: line)
    }

    func assertThatDeleteHasNoSideEffectsOnDeletionError(on sut: any FeedStore<LocalFilm>, file: StaticString = #file, line: UInt = #line) {
        
        XCTFail("Unimplemented")
//        deleteCache(from: sut)
//
//        expect(sut, toRetrieve: .success(.none), file: file, line: line)
    }
}
