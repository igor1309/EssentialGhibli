//
//  GhibliCacheCoreDataStoreIntegrationTests.swift
//  
//
//  Created by Igor Malyarov on 11.10.2022.
//

import CoreData
import GhibliDomain
import GhibliCache
import GhibliCacheInfra
import XCTest

final class GhibliCacheCoreDataStoreIntegrationTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        setupEmptyStoreState()
    }
    
    override func tearDown() {
        super.tearDown()
        undoStoreSideEffects()
    }
    
    func test_load_shouldDeliverNoItemsOnEmptyCache() throws {
        let sut = try makeSUT()
        
        expect(sut, toLoad: [])
    }
    
    func test_load_shouldDeliverItemsSavedOnASeparateInstance() throws {
        let sutToPerformSave = try makeSUT()
        let sutToPerformLoad = try makeSUT()
        let feed = uniqueFilmFeed()
        
        save(feed.feed, with: sutToPerformSave)
        
        expect(sutToPerformLoad, toLoad: feed.feed)
    }
    
    func test_save_overridesItemsSavedOnASeparateInstance() throws {
        let sutToPerformFirstSave = try makeSUT()
        let sutToPerformLastSave = try makeSUT()
        let sutToPerformLoad = try makeSUT()
        let firstFeed = uniqueFilmFeed()
        let latestFeed = uniqueFilmFeed()
        
        save(firstFeed.feed, with: sutToPerformFirstSave)
        save(latestFeed.feed, with: sutToPerformLastSave)
        
        expect(sutToPerformLoad, toLoad: latestFeed.feed)
    }
    
    // MARK: - Helpers
    
    typealias FilmFeedCache = FeedCache<GhibliFilm, CoreDataFeedStore>
    
    private func makeSUT(
        file: StaticString = #file,
        line: UInt = #line
    ) throws -> FilmFeedCache {
        let store = try CoreDataFeedStore(storeURL: testStoreURL())
        let sut = FeedCache(
            store: store,
            toLocal: LocalFilm.init(film:),
            fromLocal: GhibliFilm.init(local:)
        ) { _, _ in true }
        
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        
        return sut
    }
    
    private func expect(
        _ sut: FilmFeedCache,
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
        with sut: FilmFeedCache,
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
        NSPersistentContainer
            .defaultDirectoryURL()
            .appendingPathComponent("feed-store.sqlite")
            .appendingPathComponent("\(type(of: self)).sqlite")
    }
}
