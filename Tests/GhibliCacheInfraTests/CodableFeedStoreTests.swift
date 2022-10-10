//
//  CodableFeedStoreTests.swift
//  
//
//  Created by Igor Malyarov on 10.10.2022.
//

import GhibliCache
import GhibliCacheInfra
import XCTest

struct LocalFilm: Equatable {
    let id: UUID
    let title: String
    let description: String
    let imageURL: URL
    let filmURL: URL
}

final class CodableFeedStore {
    private let storeURL: URL
    
    init(storeURL: URL) {
        self.storeURL = storeURL
    }
    
    private struct Cache: Codable {
        private let feed: [CachedFilm]
        private let timestamp: Date
        
        init(local: [LocalFilm], timestamp: Date) {
            self.feed = local.map(CachedFilm.init)
            self.timestamp = timestamp
        }
        
        var localFeed: (feed: [LocalFilm], timestamp: Date) {
            (feed.map(\.local), timestamp)
        }
        
        private struct CachedFilm: Codable {
            private let id: UUID
            private let title: String
            private let description: String
            private let imageURL: URL
            private let filmURL: URL
            
            init(local: LocalFilm) {
                self.id = local.id
                self.title = local.title
                self.description = local.description
                self.imageURL = local.imageURL
                self.filmURL = local.filmURL
            }
            
            var local: LocalFilm {
                .init(
                    id: id,
                    title: title,
                    description: description,
                    imageURL: imageURL,
                    filmURL: filmURL
                )
            }
        }
    }
    
    func deleteCachedFeed() throws {
        try FileManager.default.removeItem(at: storeURL)
    }
    
    func insert(_ feed: [LocalFilm], timestamp: Date) throws {
        let encoder = JSONEncoder()
        let cache = Cache(local: feed, timestamp: timestamp)
        let encoded = try encoder.encode(cache)
        try encoded.write(to: storeURL)
    }
    
    func retrieve() throws -> CachedFeed<LocalFilm>? {
        guard let data = try? Data(contentsOf: storeURL)
        else { return nil }
        
        let decoder = JSONDecoder()
        let cache = try decoder.decode(Cache.self, from: data)
        
        return cache.localFeed
    }
}

final class CodableFeedStoreTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        setupEmptyStoreState()
    }
    
    override func tearDown() {
        super.tearDown()
        undoStoreSideEffects()
    }
    
    func test_retrieve_shouldDeliverEmptyCacheOnEmptyCache() {
        let sut = makeSUT()
        
        XCTAssertNoThrow {
            let feed = try sut.retrieve()
            
            XCTAssertNil(feed, "Expected retrieving from empty cache to deliver empty result.")
        }
    }
    
    func test_retrieve_shouldHaveNoSideEffectsOnEmptyCache() {
        let sut = makeSUT()
        
        XCTAssertNoThrow {
            let feed = try sut.retrieve()
            XCTAssertNil(feed)
            
            let feed2 = try sut.retrieve()
            XCTAssertNil(feed2, "Expected retrieving twice from empty cache to deliver same empty result.")
        }
    }
    
    func test_retrieve_shouldDeliverInsertedValues() {
        let sut = makeSUT()
        let feed = uniqueFilmFeed()
        let timestamp = Date()
        
        XCTAssertNoThrow {
            try sut.insert(feed, timestamp: timestamp)
            let retrieved = try sut.retrieve()
            
            XCTAssertEqual(feed, retrieved?.feed)
            XCTAssertEqual(timestamp, retrieved?.timestamp)
        }
    }
    
    func test_retrieve_shouldHaveNoSideEffectsOnNonEmptyCache() {
        let sut = makeSUT()
        let feed = uniqueFilmFeed()
        let timestamp = Date()
        
        XCTAssertNoThrow {
            try sut.insert(feed, timestamp: timestamp)
            let retrieved = try sut.retrieve()
            
            XCTAssertEqual(feed, retrieved?.feed)
            XCTAssertEqual(timestamp, retrieved?.timestamp)
            
            let retrieved2 = try XCTUnwrap(try sut.retrieve())
            
            XCTAssertEqual(feed, retrieved2.feed, "Expected retrieving twice from non empty cache to deliver same result.")
            XCTAssertEqual(timestamp, retrieved2.timestamp, "Expected retrieving twice from non empty cache to deliver same result.")
        }
    }
    
    func test_retrieve_shouldFailOnRetrievalError() throws {
        let storeURL = testStoreURL()
        let sut = makeSUT(storeURL: storeURL)
        
        try "invalid data".write(to: storeURL, atomically: true, encoding: .utf8)
        
        XCTAssertThrowsError(_ = try sut.retrieve())
    }

    func test_retrieve_shouldHaveNoSideEffectsOnRetrievalError() throws {
        let storeURL = testStoreURL()
        let sut = makeSUT(storeURL: storeURL)
        
        try "invalid data".write(to: storeURL, atomically: true, encoding: .utf8)
        
        XCTAssertThrowsError(_ = try sut.retrieve())
        XCTAssertThrowsError(_ = try sut.retrieve())
    }

    func test_retrieve_shouldOverridePreviouslyInsertedCache() {
        let sut = makeSUT()
        
        XCTAssertNoThrow {
            try sut.insert([makeLocalFilm()], timestamp: Date())
            
            let latestFeed = uniqueFilmFeed()
            let latestTimestamp = Date()
            
            try sut.insert(latestFeed, timestamp: latestTimestamp)
            let retrieved = try XCTUnwrap(try sut.retrieve())
            
            XCTAssertEqual(latestFeed, retrieved.feed)
            XCTAssertEqual(latestTimestamp, retrieved.timestamp)
        }
    }
    
    func test_insert_shouldDeliverErrorOnInsertionFailure() {
        let sut = makeSUT(storeURL: .init(string: "invalid://store-url")!)
        
        XCTAssertThrowsError(try sut.insert([], timestamp: .now))
    }
    
    func test_deleteShouldHaveNoSideEffectsOnEmptyCache() {
        let sut = makeSUT()
        
        XCTAssertNil(try sut.retrieve())
        XCTAssertNoThrow { try sut.deleteCachedFeed() }
        XCTAssertNil(try sut.retrieve())
    }
    
    func test_delete_shouldEmptyPreviouslyInsertedCache() {
        let sut = makeSUT()
        let feed = uniqueFilmFeed()
        let timestamp = Date()
        
        XCTAssertNoThrow {
            try sut.insert(feed, timestamp: timestamp)
            try sut.deleteCachedFeed()
            XCTAssertNil(try sut.retrieve())
        }
    }
    
    func test_delete_shouldDeliverErrorOnDeletionError() {
        let sut = makeSUT(storeURL: .init(string: "invalid://store-url")!)
        XCTAssertThrowsError(try sut.deleteCachedFeed())
    }

    // MARK: - Helpers
    
    private func makeSUT(
        storeURL: URL? = nil,
        file: StaticString = #file,
        line: UInt = #line
    ) -> CodableFeedStore {
        let sut = CodableFeedStore(storeURL: storeURL ?? testStoreURL())
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
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

private func uniqueFilmFeed() -> [LocalFilm] {
    [makeLocalFilm(), makeLocalFilm()]
}

private func makeLocalFilm() -> LocalFilm {
    .init(
        id: UUID(),
        title: "a title",
        description: "a description",
        imageURL: URL(string: "any-url")!,
        filmURL: URL(string: "any-url")!
    )
}
