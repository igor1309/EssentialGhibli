//
//  LoaderComposer.swift
//
//
//  Created by Igor Malyarov on 15.10.2022.
//

import API
import Cache
import CacheInfra
import Combine
import CoreData
import Foundation
import ListFeature
import SharedAPI
import SharedAPIInfra

final class LoaderComposer<Store>
where Store: FeedStore & FilmImageDataStore,
      Store.Item == ListFilm {
    
    private lazy var baseURL: URL = {
        URL(string: "https://ghibliapi.herokuapp.com")!
    }()
    
    private lazy var httpClient: HTTPClient = {
        let session = URLSession(configuration: .ephemeral)
        return URLSessionHTTPClient(session: session)
    }()
    
    private lazy var store: Store = {
        do {
            let storeURL = NSPersistentContainer
                .defaultDirectoryURL()
                .appendingPathComponent("feed-store.sqlite")
            let store = try CoreDataFeedStore(storeURL: storeURL)
            return store as! Store
        } catch {
            let store = NullStore<ListFilm>()
            return store as! Store
        }
    }()
    
    private lazy var feedCache: FeedCache<ListFilm, Store> = {
        .init(
            store: store,
            toLocal: { $0 },
            fromLocal: { $0 },
            feedCachePolicy: .sevenDays
        )
    }()
    
    init() {}
    
    convenience init(httpClient: HTTPClient, store: Store) {
        self.init()
        self.httpClient = httpClient
        self.store = store
    }
}

extension LoaderComposer {
    
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
        return httpClient
            .getPublisher(url: filmsURL)
            .tryMap(ListFilmMapper.map)
            .eraseToAnyPublisher()
    }
}

extension LoaderComposer {
    
    /// Local Image loader with remote fallback
    func filmImageLoader(url: URL) -> ImagePublisher {
        filmImageDataLocalLoaderWithRemoteFallback(url: url)
            .tryMap(ImageMapper.map)
            .subscribe(on: DispatchQueue.global())
            .eraseToAnyPublisher()
    }
    
    private func filmImageDataLocalLoaderWithRemoteFallback(url: URL) -> AnyPublisher<Data, Error> {
#warning("add caching")
        let remote = { [httpClient] in
            httpClient
                .getPublisher(url: url)
                .data(ifResponse: { $0.is200 })
            //                .caching(to: feedCache. using: url)
        }
        let cache = FilmImageDataCache(store: store)
        
        return cache.loadImageDataPublisher(from: url)
            .fallback(to: remote)
            .eraseToAnyPublisher()
    }
}
