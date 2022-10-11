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
    
    private func noDeletePermissionURL() -> URL {
        return FileManager.default.urls(for: .cachesDirectory, in: .systemDomainMask).first!
    }
}

extension CodableFeedStoreTests: FeedStoreSpecs {
    func test_retrieve_shouldDeliverEmptyOnEmptyCache() {
        let sut = makeSUT()

        assertThatRetrieveDeliversEmptyOnEmptyCache(on: sut)
    }
    
    func test_retrieve_shouldHaveNoSideEffectsOnEmptyCache() {
        let sut = makeSUT()
        
        assertThatRetrieveHasNoSideEffectsOnEmptyCache(on: sut)
    }
    
    func test_retrieve_shouldDeliverInsertedValues() {
        let sut = makeSUT()
        
        assertThatRetrieveDeliversFoundValuesOnNonEmptyCache(on: sut)
    }
    
    func test_retrieve_shouldHaveNoSideEffectsOnNonEmptyCache() {
        let sut = makeSUT()
        
        assertThatRetrieveHasNoSideEffectsOnNonEmptyCache(on: sut)
    }
    
    func test_insert_shouldDeliverNoErrorOnEmptyCache() {
        let sut = makeSUT()
        
        assertThatInsertDeliversNoErrorOnEmptyCache(on: sut)
    }
    
    func test_insert_shouldDeliverNoErrorOnNonEmptyCache() {
        let sut = makeSUT()
        
        assertThatInsertDeliversNoErrorOnNonEmptyCache(on: sut)
    }
    
    func test_insert_shouldOverridePreviouslyInsertedCache() {
        let sut = makeSUT()
        
        assertThatInsertOverridesPreviouslyInsertedCacheValues(on: sut)
    }
    
    func test_delete_shouldDeliverNoErrorOnEmptyCache() {
        let sut = makeSUT()

        assertThatDeleteDeliversNoErrorOnEmptyCache(on: sut)
    }
    
    func test_delete_shouldHaveNoSideEffectsOnEmptyCache() {
        let sut = makeSUT()
        
        assertThatDeleteHasNoSideEffectsOnEmptyCache(on: sut)
    }
    
    func test_delete_shouldDeliverNoErrorOnNonEmptyCache() throws {
        let sut = makeSUT()

        assertThatDeleteDeliversNoErrorOnNonEmptyCache(on: sut)
    }
    
   func test_delete_shouldEmptyPreviouslyInsertedCache() {
        let sut = makeSUT()
        
       assertThatDeleteEmptiesPreviouslyInsertedCache(on: sut)
    }
}

extension CodableFeedStoreTests: FailableRetrieveFeedStoreSpecs {
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
}

extension CodableFeedStoreTests: FailableInsertFeedStoreSpecs{
    func test_insert_shouldDeliverErrorOnInsertionFailure() {
        let invalidStoreURL = URL(string: "invalid://store-url")!
        let sut = makeSUT(storeURL: invalidStoreURL)
        
        XCTAssertThrowsError(try sut.insert([], timestamp: .now))
    }
    
    func test_insert_shouldHaveNoSideEffectsOnInsertionFailure() {
        let invalidStoreURL = URL(string: "invalid://store-url")!
        let sut = makeSUT(storeURL: invalidStoreURL)
        
        XCTAssertThrowsError(try sut.insert([], timestamp: .now))
    }
}

extension CodableFeedStoreTests: FailableDeleteFeedStoreSpecs {
    func test_delete_shouldDeliverErrorOnDeletionFailure() {
        let sut = makeSUT(storeURL: noDeletePermissionURL())
        
        XCTAssertThrowsError(try sut.deleteCachedFeed(), "Expected cache deletion to fail")
    }
    
    func test_delete_shouldHaveNoSideEffectsOnDeletionFailure() {
        let sut = makeSUT(storeURL: noDeletePermissionURL())
        
        XCTAssertThrowsError(try sut.deleteCachedFeed(), "Expected cache deletion to fail")
        expect(sut, toRetrieve: .success(.none))
    }
}
