//
//  XCTestCase+FailableInsertFeedStoreSpecs.swift
//  
//
//  Created by Igor Malyarov on 11.10.2022.
//

import GhibliCache
import GhibliCacheInfra
import XCTest

extension FailableInsertFeedStoreSpecs where Self: XCTestCase {
    func assertThatInsertDeliversErrorOnInsertionError<Store>(on sut: Store, file: StaticString = #file, line: UInt = #line)
    where Store: FeedStore, Store.Item == LocalFilm {
        
        XCTFail("Unimplemented")
//        let insertionError = insert((uniqueImageFeed().local, Date()), to: sut)
//
//        XCTAssertNotNil(insertionError, "Expected cache insertion to fail with an error", file: file, line: line)
    }

    func assertThatInsertHasNoSideEffectsOnInsertionError<Store>(on sut: Store, file: StaticString = #file, line: UInt = #line)
    where Store: FeedStore, Store.Item == LocalFilm {
        
        XCTFail("Unimplemented")
//        insert((uniqueImageFeed().local, Date()), to: sut)
//
//        expect(sut, toRetrieve: .success(.none), file: file, line: line)
    }
}
