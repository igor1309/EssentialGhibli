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
    
    func test_shouldDisplayEmptyList_onOfflineAndEmptyCache() {
        let sut = UIComposer(loader: .offline)

        assert(snapshot: sut, locale: .en_US, record: record)
        assert(snapshot: sut, locale: .ru_RU, record: record)
    }

    func test_shouldDisplayFilmList_onOfflineAndNonExpiredCache() {
        let sut = makeSUT(.offline, .withNonExpiredFeedCache())

        assert(snapshot: sut, locale: .en_US, record: record)
        assert(snapshot: sut, locale: .ru_RU, record: record)
    }

    func test_shouldDisplayFilmList_onOnline() {
        let sut = UIComposer(loader: .online)

        assert(snapshot: sut, locale: .en_US, record: record)
        assert(snapshot: sut, locale: .ru_RU, record: record)
    }
    
    func test_shouldDisplayCachedFilmList() {
        let store = InMemoryFeedStore.empty()
        
        let online = makeSUT(.online(response200), store)
        assert(snapshot: online, locale: .en_US, record: record)
        
        let offline = makeSUT(.offline, store)
        assert(snapshot: offline, locale: .en_US, record: record)
        assert(snapshot: offline, locale: .ru_RU, record: record)
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
        _ httpClient: HTTPClientStub,
        _ store: InMemoryFeedStore,
        file: StaticString = #file,
        line: UInt = #line
    ) -> UIComposer {
        let loader = LoaderComposer(httpClient: httpClient, store: store)
        return UIComposer(loader: loader)
    }
}
