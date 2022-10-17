//
//  LoaderComposerTests.swift
//
//
//  Created by Igor Malyarov on 14.10.2022.
//

import API
import Cache
import Combine
import DetailFeature
import Domain
@testable import EssentialGhibli
import ListFeature
import SharedAPI
import XCTest

final class LoaderComposerTests: XCTestCase {
    
    func test_shouldDeliverRemoteFeed_onOnline() {
        let sut = LoaderComposer.online
        
        expect(sut, toDeliver: .samples)
    }
    
    func test_shouldDeliverRemoteFeed_onOnlineAndNonExpiredCache() {
        let sut = makeSUT(.online(response200), .withNonExpiredFeedCache())
        
        expect(sut, toDeliver: .samples)
    }
    
    func test_shouldDeliverEmptyFilmList_onOfflineAndEmptyCache() {
        let sut = LoaderComposer.offline
        
        expect(sut, toDeliver: .empty)
    }
    
    func test_shouldDeliverCachedFilmList_onOfflineAndNonEmptyCache() {
        let store = InMemoryFeedStore.empty()
        
        let online = makeSUT(.online(response200), store)
        expect(online, toDeliver: .samples)
        
        let offline = makeSUT(.offline, store)
        expect(offline, toDeliver: .samples)
    }
    
    func test_shouldDeliverEmpty_onOfflineLoaderComposer() {
        let offline = LoaderComposer.offline
        
        expect(offline, toDeliver: .empty)
    }
    
    func test_shouldDeliverImageData_onOnlineLoaderComposer() {
        let sut = LoaderComposer.online
        let imageData = Data.uiImageData(withColor: .orange, width: 30, height: 40)
        
        expect(sut, toDeliverImageData: imageData, onSelecting: [ListFilm].samples[0])
    }
    
    func test_shouldDeliverDetail_onOnlineLoaderComposer() {
        let sut = LoaderComposer.online
        
        expect(sut, toDeliverDetailData: .castleInTheSky, onSelecting: [ListFilm].samples[0])
    }
    
    // MARK: - Helpers
    
    typealias ListFilmResult = Result<[ListFilm], MappingError>
    
    private func makeSUT(
        _ httpClient: HTTPClientStub,
        _ store: InMemoryFeedStore,
        file: StaticString = #file,
        line: UInt = #line
    ) -> LoaderComposer {
        let sut = LoaderComposer(
            httpClient: httpClient,
            store: store,
            scheduler: .immediate
        )
        
        trackForMemoryLeaks(sut, file: file, line: line)
        
        return sut
    }
    
    private func expect(
        _ sut: LoaderComposer,
        toDeliver expectedResult: ListFilmResult,
        file: StaticString = #file,
        line: UInt = #line
    ) {
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
                
            } receiveValue: { received in
                switch expectedResult {
                case let .success(expected):
                    XCTAssertEqual(received, expected, file: file, line: line)
                    
                default:
                    XCTFail("Expected \(expectedResult), got \(received) instead.", file: file, line: line)
                }
            }
        
        cancellable.cancel()
    }
    
    private func expect(
        _ sut: LoaderComposer,
        toDeliverImageData expectedData: Data,
        onSelecting listFilm: ListFilm,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        let url: URL = listFilm.imageURL
        let cancellable = sut.filmImageLoader(url: url)
            .sink { completion in
                
                switch completion {
                case let .failure(error):
                    XCTFail("Expected \(expectedData), got \(error.localizedDescription) instead.", file: file, line: line)
                    
                case .finished:
                    break
                }
                
            } receiveValue: { receivedData in
                XCTAssertEqual(receivedData, expectedData, file: file, line: line)
            }
        
        cancellable.cancel()
    }
    
    private func expect(
        _ sut: LoaderComposer,
        toDeliverDetailData expectedDetailFilm:  DetailFilm,
        onSelecting listFilm: ListFilm,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        let cancellable = sut.detailLoader(listFilm: listFilm)
            .sink { completion in
                
                switch completion {
                case let .failure(error):
                    XCTFail("Expected \(expectedDetailFilm), got \(error.localizedDescription) instead.", file: file, line: line)
                    
                case .finished:
                    break
                }
                
            } receiveValue: { receivedData in
                XCTAssertEqual(receivedData, expectedDetailFilm, file: file, line: line)
            }
        
        cancellable.cancel()
    }
}
