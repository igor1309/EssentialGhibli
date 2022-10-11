//
//  LoadFilmFromImageDataCacheUseCaseTests.swift
//  
//
//  Created by Igor Malyarov on 11.10.2022.
//

import XCTest

final class LoadFilmFromImageDataCacheUseCaseTests: XCTestCase {
    
    func test_init_shouldNotMessageStoreOnInit() throws {
        let (_, store) = makeSUT()
        
        XCTAssert(store.messages.isEmpty)
    }
    
    func test_load_shouldRequestStoreRetrieval() throws {
        let (sut, store) = makeSUT()
        
        _ = try sut.load()
        
        XCTAssertEqual(store.messages, [.retrieve])
    }
    
    func test_load_shouldDeliverErrorOnRetrievalFailure() throws {
        let (sut, store) = makeSUT()
        store.completeRetrieval(with: .error)
        
        expect(sut, toLoad: .failure(anyError()))
    }
    
    func test_load_shouldDeliverEmptyOnEmptyRetrieval() throws {
        let (sut, store) = makeSUT()
        store.completeRetrieval(with: .none)
        
        expect(sut, toLoad: .success(.none))
    }
    
    func test_load_shouldDeliverImageOnDataRetrieval() throws {
        let (sut, store) = makeSUT()
        let expectedImage = "Some data here"
        let imageData = expectedImage.data(using: .utf8)
        store.completeRetrieval(with: .success(imageData))
        
        expect(sut, toLoad: .success(expectedImage))
    }
    
    func test_load_shouldHaveNoSideEffectsOnRetrievalFailure() throws {
        let (sut, store) = makeSUT()
        
        store.completeRetrieval(with: .error)
        do {
            _ = try sut.load()
        } catch {}
        
        XCTAssertEqual(store.messages, [.retrieve])
    }
    
    func test_load_shouldHaveNoSideEffectsOnEmptyCache() throws {
        let (sut, store) = makeSUT()
        
        store.completeRetrieval(with: .none)
        _ = try sut.load()
        
        XCTAssertEqual(store.messages, [.retrieve])
    }
    
    func test_load_shouldHaveNoSideEffectsOnNonEmptyCache() throws {
        let (sut, store) = makeSUT()
        
        store.completeRetrieval(with: .someData)
        _ = try sut.load()
        
        XCTAssertEqual(store.messages, [.retrieve])
    }
    
    // MARK: - Helpers
    
    typealias Image = String
    typealias ImageResult = Result<Image?, Error>
    typealias DataCache = FilmImageDataCache<Image>
    typealias RetrievalResult = Result<Data?, Error>
    
    private func makeSUT(
        file: StaticString = #file,
        line: UInt = #line
    ) -> (sut: DataCache, store: StoreStub) {
        let store = StoreStub()
        let sut = DataCache(store: store) { .init(data: $0, encoding: .utf8) }
        
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        
        return (sut, store)
    }
    
    private final class StoreStub: FilmDataStore {
        private var retrievalResult: RetrievalResult?
        private(set) var messages = [Message]()
        
        func completeRetrieval(with result: RetrievalResult) {
            self.retrievalResult = result
        }
        
        func retrieve() throws -> Data? {
            messages.append(.retrieve)
            return try retrievalResult?.get()
        }
        
        enum Message {
            case retrieve
        }
    }
    
    private func expect(
        _ sut: DataCache,
        toLoad expectedResult: ImageResult,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        let retrievedResult = Result { try sut.load() }
        
        switch (expectedResult, retrievedResult) {
        case let (.success(expected), .success(retrieved)):
            XCTAssertEqual(expected, retrieved, file: file, line: line)
            
        case (.failure, .failure):
            break
            
        default:
            XCTFail("Expected \(expectedResult), got \(retrievedResult) instead.", file: file, line: line)
        }
    }
}

extension LoadFilmFromImageDataCacheUseCaseTests.RetrievalResult {
    static let error: Self = .failure(anyError())
    static let none: Self = .success(.none)
    static let someData: Self = .success("some data".data(using: .utf8))
}
