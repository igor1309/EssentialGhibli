//
//  FilmImageDataCacheTests.swift
//  
//
//  Created by Igor Malyarov on 11.10.2022.
//

import XCTest

protocol FilmDataStore {
    func retrieve() throws -> Data?
}

final class FilmImageDataCache<Image> {
    typealias MakeImage = (Data) -> Image?
    
    private let store: FilmDataStore
    private let makeImage: MakeImage
    
    init(
        store: FilmDataStore,
        makeImage: @escaping MakeImage
    ) {
        self.store = store
        self.makeImage = makeImage
    }
    
    func load() throws -> Image? {
        let data = try store.retrieve()
        return data.map(makeImage) ?? nil
    }
}

final class FilmImageDataCacheTests: XCTestCase {
    
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
        store.completeRetrieval(with: .failure(anyError()))

        do {
            _ = try sut.load()
            XCTFail("Expected error")
        } catch let error as AnyError {
            XCTAssertEqual(error, AnyError())
        } catch {
            XCTFail("Expected AnyError, got \(error.localizedDescription)")
        }
    }
    
    func test_load_shouldDeliverEmptyOnEmptyRetrieval() throws {
        let (sut, store) = makeSUT()
        store.completeRetrieval(with: .success(.none))

        do {
            let image = try sut.load()
            XCTAssertEqual(image, nil)
        } catch let error as AnyError {
            XCTAssertEqual(error, AnyError())
        } catch {
            XCTFail("Expected AnyError, got \(error.localizedDescription)")
        }
    }
    
    func test_load_shouldDeliverImageOnDataRetrieval() throws {
        let (sut, store) = makeSUT()
        let expectedImage = "Some data here"
        let imageData = expectedImage.data(using: .utf8)
        store.completeRetrieval(with: .success(imageData))

        do {
            let image = try sut.load()
            XCTAssertEqual(image, expectedImage)
        } catch let error as AnyError {
            XCTAssertEqual(error, AnyError())
        } catch {
            XCTFail("Expected AnyError, got \(error.localizedDescription)")
        }
    }
    
    // MARK: - Helpers
    
    typealias DataCache = FilmImageDataCache<String>
    
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
        typealias RetrievalResult = Result<Data?, Error>
        
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
}
