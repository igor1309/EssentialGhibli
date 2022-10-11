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
    
    func test_load_shouldDeliverNoItemsOnEmptyCache() {
        let sut = makeSUT()
        
        expect(sut, toLoad: [])
    }
    
    func test_load_shouldDeliverItemsSavedOnASeparateInstance() {
        let sutToPerformSave = makeSUT()
        let sutToPerformLoad = makeSUT()
        let feed = uniqueFilmFeed()
        
        save(feed.feed, with: sutToPerformSave)
        
        expect(sutToPerformLoad, toLoad: feed.feed)
    }
    
    func test_save_overridesItemsSavedOnASeparateInstance() {
        let sutToPerformFirstSave = makeSUT()
        let sutToPerformLastSave = makeSUT()
        let sutToPerformLoad = makeSUT()
        let firstFeed = uniqueFilmFeed()
        let latestFeed = uniqueFilmFeed()
        
        save(firstFeed.feed, with: sutToPerformFirstSave)
        save(latestFeed.feed, with: sutToPerformLastSave)
        
        expect(sutToPerformLoad, toLoad: latestFeed.feed)
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
            XCTAssertEqual(feed, expectedFeed, file: file, line: line)
        } catch {
            XCTFail(error.localizedDescription, file: file, line: line)
        }
    }
    
    private func save(
        _ feed: [GhibliFilm],
        with sut: LocalLoader,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        do {
            try sut.save(feed: feed, timestamp: .now)
        } catch {
            XCTFail(error.localizedDescription, file: file, line: line)
        }
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
    
    private func testStoreURL() -> URL {
        cachesDirectory().appendingPathComponent("\(type(of: self)).store")
    }
    
    private func cachesDirectory() -> URL {
        return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
    }
}
