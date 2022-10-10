//
//  CodableFeedStoreTests.swift
//  
//
//  Created by Igor Malyarov on 10.10.2022.
//

import GhibliDomain
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
    
    init(storeURL: URL? = nil) {
        self.storeURL = storeURL ?? FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            .appendingPathComponent("film-feed.store")
    }
    
    private struct Cache: Codable {
        let feed: [CachedFilm]
        let timestamp: Date
        
        struct CachedFilm: Codable {
            let id: UUID
            let title: String
            let description: String
            let imageURL: URL
            let filmURL: URL
        }
    }
    
    private func toCachedFilm(local: LocalFilm) -> Cache.CachedFilm {
        .init(
            id: local.id,
            title: local.title,
            description: local.description,
            imageURL: local.imageURL,
            filmURL: local.filmURL
        )
    }
    
    private func toLocal(cached: Cache.CachedFilm) -> LocalFilm {
        .init(
            id: cached.id,
            title: cached.title,
            description: cached.description,
            imageURL: cached.imageURL,
            filmURL: cached.filmURL
        )
    }
    
    func insert(_ feed: [LocalFilm], timestamp: Date) throws {
        let encoder = JSONEncoder()
        let cached: [Cache.CachedFilm] = feed.map(toCachedFilm)
        let cache = Cache(feed: cached, timestamp: timestamp)
        let encoded = try encoder.encode(cache)
        try encoded.write(to: storeURL)
    }
    
    func retrieve() throws -> CachedFeed<LocalFilm>? {
        guard let data = try? Data(contentsOf: storeURL)
        else {
            return nil
        }
        
        let decoder = JSONDecoder()
        let cache = try decoder.decode(Cache.self, from: data)
        
        return (cache.feed.map(toLocal), cache.timestamp)
    }
}

final class CodableFeedStoreTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        clearArtifacts()
    }
    
    override func tearDown() {
        super.tearDown()
        clearArtifacts()
    }
    
    private func clearArtifacts() {
        let storeURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            .appendingPathComponent("film-feed.store")
        try? FileManager.default.removeItem(at: storeURL)
    }
    
    func test_shouldDeliverEmptyCacheOnEmptyCache() throws {
        let sut = makeSUT()
        
        let feed = try sut.retrieve()
        
        XCTAssertNil(feed, "Expected retrieving from empty cache to deliver empty result.")
    }
    
    func test_shouldHaveNoSideEffectsOnEmptyCache() throws {
        let sut = makeSUT()
        
        let feed = try sut.retrieve()
        XCTAssertNil(feed)
        
        let feed2 = try sut.retrieve()
        XCTAssertNil(feed2, "Expected retrieving twice from empty cache to deliver same empty result.")
    }
    
    func test_retrieveAfterInsertingShouldDeliverInsertedValues() throws {
        let sut = makeSUT()
        let feed = uniqueFilmFeed()
        let timestamp = Date()
        
        try sut.insert(feed, timestamp: timestamp)
        let retrieved = try sut.retrieve()
        
        XCTAssertEqual(feed, retrieved?.feed)
        XCTAssertEqual(timestamp, retrieved?.timestamp)
    }
    
    // MRK: - Helpers
    
    private func makeSUT(
        file: StaticString = #file,
        line: UInt = #line
    ) -> CodableFeedStore {
        let sut = CodableFeedStore()
        
        trackForMemoryLeaks(sut, file: file, line: line)
        
        return sut
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
