//
//  CoreDataFilmImageDataStoreTests.swift
//  
//
//  Created by Igor Malyarov on 12.10.2022.
//

import GhibliCache
import GhibliCacheInfra
import XCTest

extension CoreDataFeedStore: FilmImageDataStore {
    public func retrieve(dataForURL url: URL) throws -> Data? {
        nil
    }
    
    public func insert(_ data: Data, for url: URL) throws {
        //fatalError("Unimplemented")
    }
}

final class CoreDataFilmImageDataStoreTests: XCTestCase {
    
    func test_retrieveFilmImageData_shouldDeliverNotFoundWhenEmpty() {
        let sut = makeSUT()
        
        expect(sut, toRetrieve: .notFound, for: .anyURL)
    }
    
    func test_retrieveFilmImageData_shouldDeliverNotFoundWhenStoredDataURLDoesNotMatch() {
        let url = URL.anyURL
        let otherURL = URL.otherURL
        let sut = makeSUT()
        
        insert(.anyData, for: url, into: sut)
        
        expect(sut, toRetrieve: .notFound, for: otherURL)
    }
    
    // MARK: - Helpers
    
    typealias RetrieveResult = Result<Data?, Error>
    
    private func makeSUT(
        file: StaticString = #file,
        line: UInt = #line
    ) -> CoreDataFeedStore {
        let storeURL = URL(fileURLWithPath: "/dev/null")
        let sut = try! CoreDataFeedStore(storeURL: storeURL)
        
        trackForMemoryLeaks(sut, file: file, line: line)
        
        return sut
    }
    
    private func expect(
        _ sut: CoreDataFeedStore,
        toRetrieve expectedResult: RetrieveResult,
        for url: URL,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        let retrievedResult = Result { try sut.retrieve(dataForURL: url) }
        
        switch (expectedResult, retrievedResult) {
        case let (.success(receivedData), .success(expectedData)):
            XCTAssertEqual(receivedData, expectedData, file: file, line: line)
            
        default:
            XCTFail("Expected \(expectedResult), got \(retrievedResult) instead.", file: file, line: line)
        }
    }
    
    private func insert(
        _ data: Data,
        for url: URL,
        into sut: CoreDataFeedStore,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        do {
            let film = makeLocalFilm()
            try sut.insert([film], timestamp: .now)
            try sut.insert(data, for: url)
        } catch {
            XCTFail("Got \(error.localizedDescription) while inserting \(data).")
        }
    }
    
    private func makeLocalFilm() -> LocalFilm {
        .init(id: .init(), title: "a title", description: "a description", imageURL: .anyURL, filmURL: .otherURL)
    }
}

private extension CoreDataFilmImageDataStoreTests.RetrieveResult {
    static let notFound: Self = .success(.none)
}

private extension URL {
    static let anyURL: Self = .init(string: "https://any-url.com")!
    static let otherURL: Self = .init(string: "https://other-url.com")!
}
