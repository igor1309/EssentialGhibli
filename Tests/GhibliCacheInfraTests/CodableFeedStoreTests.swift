//
//  CodableFeedStoreTests.swift
//  
//
//  Created by Igor Malyarov on 10.10.2022.
//

import GhibliCacheInfra
import XCTest

final class CodableFeedStoreTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        setupEmptyStoreState()
    }
    
    override func tearDown() {
        super.tearDown()
        undoStoreSideEffects()
    }
    
    func test_retrieve_shouldDeliverEmptyOnEmptyCache() {
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
    
    func test_retrieve_shouldDeliverErrorOnRetrievalFailure() {
        let storeURL = testStoreURL()
        let sut = makeSUT(storeURL: storeURL)
        
        XCTAssertNoThrow {
            try "invalid data".write(to: storeURL, atomically: true, encoding: .utf8)
            
            XCTAssertThrowsError(_ = try sut.retrieve())
        }
    }
    
    func test_retrieve_shouldHaveNoSideEffectsOnRetrievalFailure() {
        let storeURL = testStoreURL()
        let sut = makeSUT(storeURL: storeURL)
        
        XCTAssertNoThrow {
            try "invalid data".write(to: storeURL, atomically: true, encoding: .utf8)
            
            XCTAssertThrowsError(_ = try sut.retrieve())
            XCTAssertThrowsError(_ = try sut.retrieve())
        }
    }
    
    func test_insert_shouldDeliverNoErrorOnEmptyCache() {
        let sut = makeSUT()
        
        XCTAssertNoThrow(try sut.insert(uniqueFilmFeed(), timestamp: .now))
    }
    
    func test_insert_shouldDeliverNoErrorOnNonEmptyCache() {
        let sut = makeSUT()
        
        XCTAssertNoThrow(try sut.insert(uniqueFilmFeed(), timestamp: .now))
        XCTAssertNoThrow(try sut.insert(uniqueFilmFeed(), timestamp: .now))
    }
    
    func test_insert_shouldOverridePreviouslyInsertedCache() {
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
        let invalidStoreURL = URL(string: "invalid://store-url")!
        let sut = makeSUT(storeURL: invalidStoreURL)
        
        XCTAssertThrowsError(try sut.insert([], timestamp: .now))
    }
    
    func test_insert_shouldHaveNoSideEffectsOnInsertionError() {
        let invalidStoreURL = URL(string: "invalid://store-url")!
        let sut = makeSUT(storeURL: invalidStoreURL)
        
        XCTAssertThrowsError(try sut.insert([], timestamp: .now))
    }
    
    func test_delete_shouldHaveNoSideEffectsOnEmptyCache() {
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
    
    func test_delete_shouldDeliverErrorOnDeletionFailure() {
        let invalidStoreURL = URL(string: "invalid://store-url")!
        let sut = makeSUT(storeURL: invalidStoreURL)
        
        XCTAssertThrowsError(try sut.deleteCachedFeed())
    }
    
    func test_delete_shouldHaveNoSideEffectsOnDeletionError() {
        let invalidStoreURL = URL(string: "invalid://store-url")!
        let sut = makeSUT(storeURL: invalidStoreURL)
        
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
