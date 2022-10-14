//
//  LoaderComposer.swift
//
//
//  Created by Igor Malyarov on 15.10.2022.
//

import API
import Cache
import Combine
@testable import EssentialGhibli
import Foundation
import ListFeature
import SharedAPI

final class LoaderComposer<Item, Store: FeedStore<Item>> {
    private lazy var baseURL: URL = {
        URL(string: "https://ghibliapi.herokuapp.com")!
    }()
    
    private let httpClient: HTTPClient
    private let store: Store
    private let feedCache: FeedCache<Item, Store>
    
    init(httpClient: HTTPClient, store: Store) {
        self.httpClient = httpClient
        self.store = store
        self.feedCache = FeedCache(
            store: store,
            toLocal: { $0 },
            fromLocal: { $0 },
            feedCachePolicy: .sevenDays
        )
    }
}

extension LoaderComposer where Item == ListFilm {
    
    /// Remote feed loader with fallback to local feed cache
    func filmsLoader() -> AnyPublisher<[ListFilm], Error> {
        makeRemoteFeedLoader()
            .caching(to: feedCache)
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
