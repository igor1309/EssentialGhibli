//
//  PreviewLoaders.swift
//  EssentialGhibli
//
//  Created by Igor Malyarov on 14.10.2022.
//

import Combine
import DetailFeature
import Foundation
import ListFeature
import RowFeature
import SwiftUI

let filmRowImage = Image(systemName: "camera.macro")
let filmDetailImage = Image(systemName: "camera.macro")


enum PreviewLoaders {
    
    // MARK: - List
    
    static func listFilmsLoader() -> AnyPublisher<[ListFilm], Error> {
        Just(.samples)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    static func emptyListFilmsLoader() -> AnyPublisher<[ListFilm], Error> {
        Just([])
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    static func longListFilmsLoader() -> AnyPublisher<[ListFilm], Error> {
        emptyListFilmsLoader()
            .delay(for: 10, scheduler: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    static func failingListFilmsLoader() -> AnyPublisher<[ListFilm], Error> {
        Fail(outputType: [ListFilm].self, failure: anyError())
            .eraseToAnyPublisher()
    }
    
    // MARK: - Row
    
    static let filmRowImageLoader: (RowFilm) -> ImagePublisher = { rowFilm in
        Just(filmRowImage)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    static let longFilmRowImageLoader: (RowFilm) -> ImagePublisher = { rowFilm in
        filmRowImageLoader(rowFilm)
            .delay(for: 10, scheduler: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    static let failingFilmRowImageLoader: (RowFilm) -> ImagePublisher = { rowFilm in
        Fail(outputType: Image.self, failure: anyError())
            .eraseToAnyPublisher()
    }
    
    // MARK: - Detail
    
    static func detailFilmLoader() -> AnyPublisher<DetailFilm, Error> {
        Just(.castleInTheSky)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    static func filmDetailLongLoader() -> AnyPublisher<DetailFilm, Error> {
        detailFilmLoader()
            .delay(for: 10, scheduler: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    static func failingDetailFilmLoader() -> AnyPublisher<DetailFilm, Error> {
        Fail(outputType: DetailFilm.self, failure: anyError())
            .eraseToAnyPublisher()
    }
    
    static let detailFilmImageLoader: (DetailFilm) -> ImagePublisher = { detailFilm in
        Just(filmDetailImage)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    static let longDetailFilmImageLoader: (DetailFilm) -> ImagePublisher = { detailFilm in
        Just(filmDetailImage)
            .delay(for: 10, scheduler: DispatchQueue.main)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    static let failingDetailFilmImageLoader: (DetailFilm) -> ImagePublisher = { detailFilm in
        Fail(outputType: Image.self, failure: anyError())
            .eraseToAnyPublisher()
    }
}
