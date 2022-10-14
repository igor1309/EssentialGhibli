//
//  LoaderComposerTests.swift
//  EssentialGhibliTests
//
//  Created by Igor Malyarov on 14.10.2022.
//

import API
import Cache
import Combine
import Domain
@testable import EssentialGhibli
import ListFeature
import SharedAPI
import XCTest

final class LoaderComposer<Store: FeedStore> {
    private lazy var baseURL: URL = {
        URL(string: "https://ghibliapi.herokuapp.com")!
    }()
    
    private let httpClient: HTTPClient
    private let store: Store
    private let feedCache: FeedCache<ListFilm, Store>
    
    init(httpClient: HTTPClient, store: Store) {
        self.httpClient = httpClient
        self.store = store
        self.feedCache = FeedCache(
            store: store,
            toLocal: { _ in fatalError() },
            fromLocal: { _ in fatalError() },
            feedCachePolicy: .sevenDays
        )
    }
}

extension LoaderComposer {
    func filmsLoader() -> AnyPublisher<[ListFilm], Error> {
        makeRemoteFeedLoader()
        // .caching(to: feedCache)
            .fallback(to: feedCache.loadPublisher)
            .subscribe(on: DispatchQueue.global())
            .eraseToAnyPublisher()
    }
    
    private func makeRemoteFeedLoader() -> AnyPublisher<[ListFilm], Error> {
        let filmsURL = FeedEndpoint.films.url(baseURL: baseURL)
        return httpClient.getPublisher(url: filmsURL)
            .tryMap(ListFilmMapper.map)
            .eraseToAnyPublisher()
    }
}

public extension HTTPClient {
    typealias Publisher = AnyPublisher<(Data, HTTPURLResponse), Error>
    
    func getPublisher(url: URL) -> Publisher {
        var task: HTTPClientTask?
        
        return Deferred {
            Future { completion in
                task = self.get(from: url, completion: completion)
            }
        }
        .handleEvents(receiveCancel: { task?.cancel() })
        .eraseToAnyPublisher()
    }
}

public extension FeedCache {
    typealias Publisher = AnyPublisher<[Item], Error>
    
    func loadPublisher() -> Publisher {
        Deferred {
            Future { completion in
                completion(Result { try self.load() })
            }
        }
        .eraseToAnyPublisher()
    }
}

extension Publisher {
    func fallback(
        to fallbackPublisher: @escaping () -> AnyPublisher<Output, Failure>
    ) -> AnyPublisher<Output, Failure> {
        self.catch { _ in fallbackPublisher() }
            .eraseToAnyPublisher()
    }
}

extension Publisher {
    func caching(to cache: any FeedSaver<ListFilm>) -> AnyPublisher<Output, Failure> where Output == [ListFilm] {
        handleEvents(receiveOutput: cache.saveIgnoringResult).eraseToAnyPublisher()
    }
}

private extension FeedSaver {
    func saveIgnoringResult(_ feed: [Item]) {
        try? save(feed: feed, timestamp: .now)
    }
}


final class LoaderComposerTests: XCTestCase {
    
    func test_shouldDeliverEmptyFilmListIfOfflineAndEmptyCache() {
        let sut = makeSUT(.offline, .empty)
        
        expect(sut, toDeliver: .empty)
    }
    
    // MARK: - Helpers
    
    typealias ListFilmResult = Result<[ListFilm], MappingError>
    
    private func expect<Store: FeedStore>(
        _ sut: LoaderComposer<Store>,
        toDeliver expectedResult: ListFilmResult,
        inTime interval: TimeInterval = 1,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        let expectation = expectation(description: "Wait for load to complete")
        
        let cancellable = sut.filmsLoader()
            .sink { completion in
                
                switch (expectedResult, completion) {
                case let (.failure(expected as NSError), .failure(received as NSError)):
                    XCTAssertEqual(expected, received, file: file, line: line)
                    
                case (_, .finished):
                    break
                    
                default:
                    XCTFail("Expected \(expectedResult), got \(completion) instead.", file: file, line: line)
                }
                
                expectation.fulfill()
            } receiveValue: { received in
                switch expectedResult {
                case let .success(expected):
                    XCTAssertEqual(expected, received, file: file, line: line)
                    
                default:
                    XCTFail("Expected \(expectedResult), got \(received) instead.", file: file, line: line)
                    
                }
            }
        
        let result = XCTWaiter.wait(for: [expectation], timeout: interval)
        
        switch result {
        case .timedOut:
            XCTFail("Timed out: the pipeline did not produce any output.", file: file, line: line)
            
        case .completed:
            break
            
        default:
            XCTFail("Expectation issue: \(result).", file: file, line: line)
        }
        
        cancellable.cancel()
    }
    
    private func makeSUT(
        _ httpClient: HTTPClientStub,
        _ store: InMemoryFeedStore,
        file: StaticString = #file,
        line: UInt = #line
    ) -> LoaderComposer<InMemoryFeedStore> {
        makeSUT(httpClient: httpClient, store: store, file: file, line: line)
    }
    
    private func makeSUT<Store: FeedStore>(
        httpClient: HTTPClient,
        store: Store,
        file: StaticString = #file,
        line: UInt = #line
    ) -> LoaderComposer<Store> {
        let sut = LoaderComposer(httpClient: httpClient, store: store)
        
        trackForMemoryLeaks(sut, file: file, line: line)
        
        return sut
    }
    
    private final class HTTPClientStub: HTTPClient {
        static let offline = HTTPClientStub(result: .error)
        
        private let result: HTTPResult
        
        init(result: HTTPResult) {
            self.result = result
        }
        
        private class ClientTask: HTTPClientTask {
            func cancel() {}
        }
        
        func get(
            from url: URL, completion: @escaping (HTTPResult) -> Void
        ) -> HTTPClientTask {
            completion(result)
            return ClientTask()
        }
    }
    
    private final class InMemoryFeedStore: FeedStore {
        typealias Item = ListFilm
        
        static let empty = InMemoryFeedStore(cached: nil)
        // static let nonExpired = InMemoryFeedStore(cached: (.samples, .now))
        // static let expired = InMemoryFeedStore(cached: (.samples, .distantPast))
        
        private var cached: CachedFeed<ListFilm>?
        
        init(cached: CachedFeed<ListFilm>?) {
            self.cached = cached
        }
        
        func deleteCachedFeed() throws {
            cached = nil
        }
        
        func insert(_ feed: [ListFeature.ListFilm], timestamp: Date) throws {
            cached = (feed, timestamp)
        }
        
        func retrieve() throws -> Cache.CachedFeed<ListFilm>? {
            cached
        }
        
    }
}

extension HTTPClient.HTTPResult {
    static let error: Self = .failure(anyError(message: "offline"))
}

extension LoaderComposerTests.ListFilmResult {
    static let badResponse: Self = .failure(.badResponse)
    static let invalidData: Self = .failure(.invalidData)
    static let empty: Self = .success([])
    static let samples: Self = .success(.samples)
}
