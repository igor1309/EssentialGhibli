//
//  GhibliCacheCodableStoreIntegrationTests.swift
//  
//
//  Created by Igor Malyarov on 11.10.2022.
//

import GhibliDomain
import GhibliCache
import GhibliCacheInfra
import XCTest

final class GhibliCacheCodableStoreIntegrationTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        setupEmptyStoreState()
    }
    
    override func tearDown() {
        super.tearDown()
        undoStoreSideEffects()
    }
    
    func test_load_deliversNoItemsOnEmptyCache() {
        let sut = makeSUT()
        
        expect(sut, toLoad: [])
    }
    
    // MARK: - Helpers
    
    typealias LocalLoader = LocalFeedLoader<GhibliFilm, CodableFeedStore>
    
    private func makeSUT(
        file: StaticString = #file,
        line: UInt = #line
    ) -> LocalLoader {
        let store = CodableFeedStore(storeURL: testStoreURL())
        let sut = LocalFeedLoader(
            store: store,
            toLocal: LocalFilm.init(film:),
            fromLocal: GhibliFilm.init(local:)
        ) { _, _ in true }
        
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        
        return sut
    }
    
    private func expect(
        _ sut: LocalLoader,
        toLoad expectedFeed: [GhibliFilm],
        file: StaticString = #file,
        line: UInt = #line
    ) {
        do {
            let feed = try sut.load()
            XCTAssertEqual(feed, expectedFeed)
        } catch {
            XCTFail(error.localizedDescription, file: file, line: line)
        }
    }
    
    private func testStoreURL() -> URL {
        FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
            .appendingPathComponent("\(type(of: self)).store")
    }
    
    private func setupEmptyStoreState() {
        clearArtifacts()
    }
    
    private func undoStoreSideEffects() {
        clearArtifacts()
    }
    
    private func clearArtifacts() {
        try? FileManager.default.removeItem(at: testStoreURL())
    }
}
