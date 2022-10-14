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

