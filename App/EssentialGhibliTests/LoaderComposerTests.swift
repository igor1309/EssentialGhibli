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

final class LoaderComposerTests: XCTestCase {
    
    func test_shouldDeliverRemoteFeedIfOnline() {
        let sut = makeSUT(.online, .empty())
        
        expect(sut, toDeliver: .samples)
    }
    
    func test_shouldDeliverRemoteFeedIfOnlineAndNonEmptyCache() {
        let feed = [ListFilm.kikisDeliveryService]
        let nonEmpty = InMemoryFeedStore(cached: (feed: feed, .now))
        let sut = makeSUT(.online, nonEmpty)
        
        expect(sut, toDeliver: .samples)
    }
    
    func test_shouldDeliverEmptyFilmListIfOfflineAndEmptyCache() {
        let sut = makeSUT(.offline, .empty())
        
        expect(sut, toDeliver: .empty)
    }
    
    func test_shouldDeliverCachedFilmListIfOfflineAndNonEmptyCache() {
        let store = InMemoryFeedStore.empty()
        
        let online = makeSUT(.online, store)
        expect(online, toDeliver: .samples)
        
        let offline = makeSUT(.offline, store)
        expect(offline, toDeliver: .samples)
    }
    
    // MARK: - Helpers
    
    typealias ListFilmResult = Result<[ListFilm], MappingError>
    
    private func makeSUT(
        _ httpClient: HTTPClientStub,
        _ store: InMemoryFeedStore,
        file: StaticString = #file,
        line: UInt = #line
    ) -> LoaderComposer<ListFilm, InMemoryFeedStore> {
        makeSUT(httpClient: httpClient, store: store, file: file, line: line)
    }
    
    private func makeSUT<Store: FeedStore>(
        httpClient: HTTPClient,
        store: Store,
        file: StaticString = #file,
        line: UInt = #line
    ) -> LoaderComposer<ListFilm, Store> {
        let sut = LoaderComposer(httpClient: httpClient, store: store)
        
        trackForMemoryLeaks(sut, file: file, line: line)
        
        return sut
    }
    
    private func expect<Store: FeedStore>(
        _ sut: LoaderComposer<ListFilm, Store>,
        toDeliver expectedResult: ListFilmResult,
        inTime interval: TimeInterval = 1,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        let expectation = expectation(description: "Wait for load to complete")
        
        let cancellable = sut.filmsLoader()
            .sink { completion in
                
                switch (completion, expectedResult) {
                case let (.failure(received as NSError), .failure(expected as NSError)):
                    XCTAssertEqual(received, expected, file: file, line: line)
                    
                case (.finished, _):
                    break
                    
                default:
                    XCTFail("Expected \(expectedResult), got \(completion) instead.", file: file, line: line)
                }
                
                expectation.fulfill()
            } receiveValue: { received in
                switch expectedResult {
                case let .success(expected):
                    XCTAssertEqual(received, expected, file: file, line: line)
                    
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
}
