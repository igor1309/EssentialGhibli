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
        clearArtifacts()
    }
    
    override func tearDown() {
        super.tearDown()
        clearArtifacts()
    }
    
    private func clearArtifacts() {
        try? FileManager.default.removeItem(at: testStoreURL())
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
        let sut = CodableFeedStore(storeURL: testStoreURL())
        
        trackForMemoryLeaks(sut, file: file, line: line)
        
        return sut
    }
    
    private func testStoreURL() -> URL {
        FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
            .appendingPathComponent("\(type(of: self)).store")
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
