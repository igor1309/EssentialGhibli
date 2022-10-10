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
    func assertThatDeleteDeliversErrorOnDeletionError<Store>(on sut: Store, file: StaticString = #file, line: UInt = #line)
    where Store: FeedStore, Store.Item == LocalFilm {
        
        XCTFail("Unimplemented")
//        let deletionError = deleteCache(from: sut)
//
//        XCTAssertNotNil(deletionError, "Expected cache deletion to fail", file: file, line: line)
    }

    func assertThatDeleteHasNoSideEffectsOnDeletionError<Store>(on sut: Store, file: StaticString = #file, line: UInt = #line)
    where Store: FeedStore, Store.Item == LocalFilm {
        
        XCTFail("Unimplemented")
//        deleteCache(from: sut)
//
//        expect(sut, toRetrieve: .success(.none), file: file, line: line)
    }
}
