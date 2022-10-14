//
//  Loaders.swift
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


// MARK: - Loaders (Publishers)

// MARK: - List

let listFilmsLoader: () -> AnyPublisher<[ListFilm], Error> = {
    Just(.samples)
        .setFailureType(to: Error.self)
        .eraseToAnyPublisher()
}

let emptyListFilmsLoader: () -> AnyPublisher<[ListFilm], Error> = {
    Just([])
        .setFailureType(to: Error.self)
        .eraseToAnyPublisher()
}

let longListFilmsLoader: () -> AnyPublisher<[ListFilm], Error> = {
    emptyListFilmsLoader()
        .delay(for: 10, scheduler: DispatchQueue.main)
        .eraseToAnyPublisher()
}

let failingListFilmsLoader: () -> AnyPublisher<[ListFilm], Error> = {
    Fail(outputType: [ListFilm].self, failure: anyError())
        .eraseToAnyPublisher()
}

    // MARK: - Row

let filmRowImageLoader: (RowFilm) -> ImagePublisher = { _ in
    Just(filmRowImage)
        .setFailureType(to: Error.self)
        .eraseToAnyPublisher()
}

let longFilmRowImageLoader: (RowFilm) -> ImagePublisher = {
    filmRowImageLoader($0)
        .delay(for: 10, scheduler: DispatchQueue.main)
        .eraseToAnyPublisher()
}

let failingFilmRowImageLoader: (RowFilm) -> ImagePublisher = { _ in
    Fail(outputType: Image.self, failure: anyError())
        .eraseToAnyPublisher()
}

// MARK: - Detail

let detailFilmLoader: () -> AnyPublisher<DetailFilm, Error> = {
    Just(.castleInTheSky)
        .setFailureType(to: Error.self)
        .eraseToAnyPublisher()
}

let filmDetailLongLoader: () -> AnyPublisher<DetailFilm, Error> = {
    detailFilmLoader()
        .delay(for: 10, scheduler: DispatchQueue.main)
        .eraseToAnyPublisher()
}

let failingDetailFilmLoader: () -> AnyPublisher<DetailFilm, Error> = {
    Fail(outputType: DetailFilm.self, failure: anyError())
        .eraseToAnyPublisher()
}

let detailFilmImageLoader: (DetailFilm) -> ImagePublisher = { _ in
    Just(filmDetailImage)
        .setFailureType(to: Error.self)
        .eraseToAnyPublisher()
}

let longDetailFilmImageLoader: (DetailFilm) -> ImagePublisher = { _ in
    Just(filmDetailImage)
        .delay(for: 10, scheduler: DispatchQueue.main)
        .setFailureType(to: Error.self)
        .eraseToAnyPublisher()
}

let failingDetailFilmImageLoader: (DetailFilm) -> ImagePublisher = { _ in
    Fail(outputType: Image.self, failure: anyError())
        .eraseToAnyPublisher()
}
