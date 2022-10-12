//
//  XCTestCase+FailableInsertFeedStoreSpecs.swift
//  
//
//  Created by Igor Malyarov on 11.10.2022.
//

import GhibliCache
import CacheInfra
import XCTest

extension FailableInsertFeedStoreSpecs where Self: XCTestCase {
    func assertThatInsertDeliversErrorOnInsertionError(on sut: any FeedStore<LocalFilm>, file: StaticString = #file, line: UInt = #line) {
        
        XCTFail("Unimplemented")
//        let insertionError = insert((uniqueImageFeed().local, Date()), to: sut)
//
//        XCTAssertNotNil(insertionError, "Expected cache insertion to fail with an error", file: file, line: line)
    }

    func assertThatInsertHasNoSideEffectsOnInsertionError(on sut: any FeedStore<LocalFilm>, file: StaticString = #file, line: UInt = #line) {
        
        XCTFail("Unimplemented")
//        insert((uniqueImageFeed().local, Date()), to: sut)
//
//        expect(sut, toRetrieve: .success(.none), file: file, line: line)
    }
}
