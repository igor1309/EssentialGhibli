//
//  CombineHelpers.swift
//  EssentialGhibliTests
//
//  Created by Igor Malyarov on 15.10.2022.
//

import Combine
import Cache
import Domain
import Foundation
import SharedAPI
import ListFeature

extension Publisher where Output == (Data, HTTPURLResponse) {
    func data(
        ifResponse predicate: @escaping (HTTPURLResponse) -> Bool
    ) -> AnyPublisher<Data, Error> {
        self.tryMap { (data, response) in
            guard predicate(response) else {
                throw MappingError.badResponse
            }
            
            guard !data.isEmpty else {
                throw MappingError.invalidData
            }
            
            return data
        }
        .eraseToAnyPublisher()
    }
}

extension Publisher {
    func caching<Item>(
        to cache: some FeedSaver<Item>
    ) -> AnyPublisher<Output, Failure>
    where Output == [Item] {
        handleEvents(receiveOutput: cache.saveNowIgnoringError)
            .eraseToAnyPublisher()
    }
}

private extension FeedSaver {
    func saveNowIgnoringError(_ feed: [Item]) {
        try? save(feed: feed, timestamp: .now)
    }
}

extension FeedCache {
    func loadPublisher() -> AnyPublisher<[Item], Error> {
        Deferred {
            Future { completion in
                completion(Result { try self.load() })
            }
        }
        .eraseToAnyPublisher()
    }
}

public extension FilmImageDataLoader {
    func loadImageDataPublisher(from url: URL) -> AnyPublisher<Data, Error> {
        return Deferred {
            Future { completion in
                completion(Result {
                    try self.loadImageData(from: url)
                })
            }
        }
        .eraseToAnyPublisher()
    }
}

public extension HTTPClient {    
    func getPublisher(url: URL) -> AnyPublisher<(Data, HTTPURLResponse), Error> {
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
