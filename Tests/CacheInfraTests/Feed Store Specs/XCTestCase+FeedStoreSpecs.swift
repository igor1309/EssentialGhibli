//
//  XCTestCase+FeedStoreSpecs.swift
//  
//
//  Created by Igor Malyarov on 10.10.2022.
//

import Cache
import CacheInfra
import XCTest

extension FeedStoreSpecs where Self: XCTestCase {
    func assertThatRetrieveDeliversEmptyOnEmptyCache(on sut: FeedStore, file: StaticString = #file, line: UInt = #line) {
        
        expect(sut, toRetrieve: .success(.none), file: file, line: line)
    }
    
    func assertThatRetrieveHasNoSideEffectsOnEmptyCache(on sut: FeedStore, file: StaticString = #file, line: UInt = #line) {
        
        expect(sut, toRetrieveTwice: .success(.none), file: file, line: line)
    }
    
    func assertThatRetrieveDeliversFoundValuesOnNonEmptyCache(on sut: FeedStore, file: StaticString = #file, line: UInt = #line) {
        
        do {
            let feed = uniqueFilmFeed()
            let timestamp = Date()
            try sut.insert(feed, timestamp: timestamp)
    
            expect(sut, toRetrieve: .success((feed: feed, timestamp: timestamp)), file: file, line: line)
        } catch {
            XCTFail(error.localizedDescription, file: file, line: line)
        }
    }
    
    func assertThatRetrieveHasNoSideEffectsOnNonEmptyCache(on sut: FeedStore, file: StaticString = #file, line: UInt = #line) {
        
        do {
            let feed = uniqueFilmFeed()
            let timestamp = Date()
            try sut.insert(feed, timestamp: timestamp)
        
            expect(sut, toRetrieveTwice: .success((feed: feed, timestamp: timestamp)), file: file, line: line)
        } catch {
            XCTFail(error.localizedDescription, file: file, line: line)
        }
    }
    
    func assertThatInsertDeliversNoErrorOnEmptyCache(on sut: FeedStore, file: StaticString = #file, line: UInt = #line) {
        
        XCTAssertNoThrow(try sut.insert(uniqueFilmFeed(), timestamp: .now), file: file, line: line)
        
    }
    
    func assertThatInsertDeliversNoErrorOnNonEmptyCache(on sut: FeedStore, file: StaticString = #file, line: UInt = #line) {
        
        XCTAssertNoThrow(try sut.insert(uniqueFilmFeed(), timestamp: .now), file: file, line: line)
        XCTAssertNoThrow(try sut.insert(uniqueFilmFeed(), timestamp: .now), file: file, line: line)
    }
    
    func assertThatInsertOverridesPreviouslyInsertedCacheValues(on sut: FeedStore, file: StaticString = #file, line: UInt = #line) {
        
        do {
            try sut.insert([makeLocalFilm()], timestamp: Date())
            
            let latestFeed = uniqueFilmFeed()
            let latestTimestamp = Date()
            
            try sut.insert(latestFeed, timestamp: latestTimestamp)
            
            expect(sut, toRetrieve: .success((latestFeed, timestamp: latestTimestamp)), file: file, line: line)
        } catch {
            XCTFail(error.localizedDescription, file: file, line: line)
        }
    }
    
    func assertThatDeleteDeliversNoErrorOnEmptyCache(on sut: FeedStore, file: StaticString = #file, line: UInt = #line) {
        
        expect(sut, toRetrieve: .success(.none), file: file, line: line)
        XCTAssertNoThrow({ try sut.deleteCachedFeed() }, file: file, line: line)
    }
    
    func assertThatDeleteHasNoSideEffectsOnEmptyCache(on sut: FeedStore, file: StaticString = #file, line: UInt = #line) {
        
        XCTAssertNoThrow({ try sut.deleteCachedFeed() }, file: file, line: line)
        expect(sut, toRetrieve: .success(.none), file: file, line: line)
    }
    
    func assertThatDeleteDeliversNoErrorOnNonEmptyCache(on sut: FeedStore, file: StaticString = #file, line: UInt = #line) {
        
        let feed = uniqueFilmFeed()
        let timestamp = Date()
        
        do {
            try sut.insert(feed, timestamp: timestamp)
            expect(sut, toRetrieve: .success((feed, timestamp)), file: file, line: line)

            try sut.deleteCachedFeed()
            expect(sut, toRetrieve: .success(.none), file: file, line: line)
        } catch {
            XCTFail(error.localizedDescription, file: file, line: line)
        }
    }
    
    func assertThatDeleteEmptiesPreviouslyInsertedCache(on sut: FeedStore, file: StaticString = #file, line: UInt = #line) {
        
        let feed = uniqueFilmFeed()
        let timestamp = Date()
        
        do {
            try sut.insert(feed, timestamp: timestamp)
            expect(sut, toRetrieve: .success((feed, timestamp)), file: file, line: line)
            
            try sut.deleteCachedFeed()
            expect(sut, toRetrieve: .success(.none), file: file, line: line)
        } catch {
            XCTFail(error.localizedDescription, file: file, line: line)
        }
    }
}

// MARK: - Helpers

extension FeedStoreSpecs where Self: XCTestCase {
    typealias RetrievalResult = Result<(feed: [LocalFilm], timestamp: Date)?, Error>
    
    func expect(_ sut: FeedStore, toRetrieveTwice expectedResult: RetrievalResult, file: StaticString = #file, line: UInt = #line) {
        
        expect(sut, toRetrieve: expectedResult, file: file, line: line)
        expect(sut, toRetrieve: expectedResult, file: file, line: line)
    }
    
    func expect(
        _ sut: FeedStore,
        toRetrieve expectedResult: RetrievalResult,
        file: StaticString = #file,
        line: UInt = #line
    ) {        
        let retrievedResult = Result { try sut.retrieve() }
        
        switch (expectedResult, retrievedResult) {
        case (.success(.none), .success(.none)),
            (.failure, .failure):
            break
            
        case let (.success(.some(expected)), .success(.some(retrieved))):
            XCTAssertEqual(retrieved.feed, expected.feed, file: file, line: line)
            XCTAssertEqual(retrieved.timestamp, expected.timestamp, file: file, line: line)
            
        default:
            XCTFail("Expected to retrieve \(expectedResult), got \(retrievedResult) instead", file: file, line: line)
        }
    }
}
