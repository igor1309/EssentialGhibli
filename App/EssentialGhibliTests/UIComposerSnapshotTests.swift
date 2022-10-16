//
//  UIComposerSnapshotTests.swift
//  EssentialGhibliTests
//
//  Created by Igor Malyarov on 15.10.2022.
//

import SharedAPI
@testable import EssentialGhibli
import XCTest

final class UIComposerSnapshotTests: XCTestCase {
    let record = true
    
    func test() async throws {
        let sut = UIComposer(loader: .offline)
        
        try await asyncAssert(snapshot: sut, locale: .en_US, record: record, wait: NSEC_PER_SEC)
    }
    
    func test_shouldDisplayEmptyList_offlineAndEmptyCache_async() async throws {
        let sut = UIComposer(loader: .offline)
        
        try await asyncAssert(snapshot: sut, locale: .en_US, record: record)
    }
    
    func test_shouldDisplayEmptyList_offlineAndEmptyCache() {
        let sut = UIComposer(loader: .offline)

        pause(for: 1)
        
        assert(snapshot: sut, locale: .en_US, record: record)
        XCTFail("SNAPSHOT IS NOT CORRECT")
        dump(sut)
    }

//    func test_shouldDisplayFilmList_onlineAndEmptyCache() {
//        let sut = makeSUT(connectivity: .online, store: .empty())
//
////        pause(for: 1)
//
//        assert(snapshot: sut, locale: .en_US, record: record)
//        assert(snapshot: sut, locale: .ru_RU, record: record)
//        XCTFail("NOT CORRECT")
//    }

    // MARK: - Helpers

    private func makeSUT(
        connectivity httpClient: HTTPClientStub,
        store: InMemoryFeedStore,
        file: StaticString = #file,
        line: UInt = #line
    ) -> UIComposer {
        let loader = LoaderComposer(httpClient: httpClient, store: store)
        return UIComposer(loader: loader)
    }
}
