//
//  LoaderFactory.swift
//  EssentialGhibli
//
//  Created by Igor Malyarov on 14.10.2022.
//

import API
import Combine
import DetailFeature
import ListFeature
import RowFeature
import Foundation

typealias Loader = (URL) -> AnyPublisher<DataResponse, Error>

enum LoaderFactory {
    static let baseURL = URL(string: "https://ghibliapi.herokuapp.com")!
    
#warning("add fallback strategies, caching...")
    
    static func filmsLoader(loader: @escaping Loader) -> () -> AnyPublisher<[ListFilm], Error> {
        return {
            let filmsURL = FeedEndpoint.films.url(baseURL: baseURL)
            let filmsLoader =
            loader(filmsURL).tryMap(ListFilmMapper.map).eraseToAnyPublisher()
            
            return filmsLoader
        }
    }
    
    static func filmRowImageLoader(loader: @escaping Loader) -> (RowFilm) -> ImagePublisher {
        return { rowFilm in
            loader(rowFilm.imageURL)
                .tryMap(ImageMapper.map)
                .eraseToAnyPublisher()
        }
    }
    
    static func detailLoader(loader: @escaping Loader) -> (ListFilm) -> AnyPublisher<DetailFilm, Error> {
        return { listFilm in
            let filmURL = FeedEndpoint.film(filmID: listFilm.id.uuidString).url(baseURL: baseURL)
            
            return loader(filmURL)
                .tryMap(DetailFilmMapper.map)
                .eraseToAnyPublisher()
        }
    }
    
    static func filmDetailImageLoader(loader: @escaping Loader) -> (DetailFilm) -> ImagePublisher {
        return { detailFilm in
            loader(detailFilm.imageURL)
                .tryMap(ImageMapper.map)
                .eraseToAnyPublisher()
        }
    }
}
