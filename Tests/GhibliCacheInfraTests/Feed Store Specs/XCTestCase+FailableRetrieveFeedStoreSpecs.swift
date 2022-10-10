//
//  XCTestCase+FailableRetrieveFeedStoreSpecs.swift
//  
//
//  Created by Igor Malyarov on 11.10.2022.
//

import GhibliCache
import GhibliCacheInfra
import XCTest

extension FailableRetrieveFeedStoreSpecs where Self: XCTestCase {
    func assertThatRetrieveDeliversFailureOnRetrievalError<Store>(on sut: Store, file: StaticString = #file, line: UInt = #line)
    where Store: FeedStore, Store.Item == LocalFilm {
        
        XCTFail("Unimplemented")//expect(sut, toRetrieve: .failure(anyError()), file: file, line: line)
    }

    func assertThatRetrieveHasNoSideEffectsOnFailure<Store>(on sut: Store, file: StaticString = #file, line: UInt = #line)
    where Store: FeedStore, Store.Item == LocalFilm {
        
        XCTFail("Unimplemented")//expect(sut, toRetrieveTwice: .failure(anyError()), file: file, line: line)
    }
}
