//
//  XCTestCase+FailableRetrieveFeedStoreSpecs.swift
//  
//
//  Created by Igor Malyarov on 11.10.2022.
//

import Cache
import CacheInfra
import XCTest

extension FailableRetrieveFeedStoreSpecs where Self: XCTestCase {
    func assertThatRetrieveDeliversFailureOnRetrievalError(on sut: FeedStore, file: StaticString = #file, line: UInt = #line) {
        
        XCTFail("Unimplemented")//expect(sut, toRetrieve: .failure(anyError()), file: file, line: line)
    }

    func assertThatRetrieveHasNoSideEffectsOnFailure(on sut: FeedStore, file: StaticString = #file, line: UInt = #line) {
        
        XCTFail("Unimplemented")//expect(sut, toRetrieveTwice: .failure(anyError()), file: file, line: line)
    }
}
