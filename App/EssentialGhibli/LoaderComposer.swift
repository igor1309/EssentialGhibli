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
import DetailFeature
import Foundation
import ListFeature
import SharedAPI
import SharedAPIInfra

final class LoaderComposer {
    
    private lazy var baseURL: URL = {
        URL(string: "https://ghibliapi.herokuapp.com")!
    }()
    
    private lazy var httpClient: HTTPClient = {
        let session = URLSession(configuration: .ephemeral)
        return URLSessionHTTPClient(session: session)
    }()
    
    private lazy var store: FeedStore & FilmImageDataStore = {
        do {
            let storeURL = NSPersistentContainer
                .defaultDirectoryURL()
                .appendingPathComponent("feed-store.sqlite")
            let store = try CoreDataFeedStore(storeURL: storeURL)
            return store
        } catch {
            let store = NullStore<ListFilm>()
            return store
        }
    }()
    
    private lazy var feedCache: FeedCache<ListFilm> = {
        .init(
            store: store,
            toLocal: LocalFilm.init(listFilm:),
            fromLocal: ListFilm.init(localFilm:),
            feedCachePolicy: .sevenDays
        )
    }()
    
    init() {}
    
    convenience init(httpClient: HTTPClient, store: FeedStore & FilmImageDataStore) {
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
//            .subscribe(on: DispatchQueue.global())
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
//            .subscribe(on: DispatchQueue.global())
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

extension LoaderComposer {
    func detailLoader(listFilm: ListFilm) -> AnyPublisher<DetailFilm, Error> {
        let filmURL = FeedEndpoint.film(filmID: listFilm.id.uuidString).url(baseURL: baseURL)
        
        return httpClient
            .getPublisher(url: filmURL)
            .tryMap(DetailFilmMapper.map)
//            .subscribe(on: DispatchQueue.global())
            .eraseToAnyPublisher()
    }
}

private extension ListFilm {
    init(localFilm: LocalFilm) {
        self.init(
            id: localFilm.id,
            title: localFilm.title,
            description: localFilm.description,
            imageURL: localFilm.imageURL,
            filmURL: localFilm.filmURL
        )
    }
}

private extension LocalFilm {
    init(listFilm: ListFilm) {
        self.init(
            id: listFilm.id,
            title: listFilm.title,
            description: listFilm.description,
            imageURL: listFilm.imageURL,
            filmURL: listFilm.filmURL
        )
    }
}
