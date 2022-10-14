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

let filmsLoader: () -> AnyPublisher<[ListFilm], Error> = {
    Just(.samples)
        .setFailureType(to: Error.self)
        .eraseToAnyPublisher()
}

let emptyFilmsLoader: () -> AnyPublisher<[ListFilm], Error> = {
    Just([])
        .setFailureType(to: Error.self)
        .eraseToAnyPublisher()
}

let longFilmsLoader: () -> AnyPublisher<[ListFilm], Error> = {
    emptyFilmsLoader()
        .delay(for: 10, scheduler: DispatchQueue.main)
        .eraseToAnyPublisher()
}

let failingFilmsLoader: () -> AnyPublisher<[ListFilm], Error> = {
    Fail(outputType: [ListFilm].self, failure: anyError())
        .eraseToAnyPublisher()
}

    // MARK: - Row

let filmRowImageLoader: (RowFilm) -> ImagePublisher = { _ in
    Just(filmRowImage)
        .setFailureType(to: Error.self)
        .eraseToAnyPublisher()
}

let filmRowLongImageLoader: (RowFilm) -> ImagePublisher = {
    filmRowImageLoader($0)
        .delay(for: 10, scheduler: DispatchQueue.main)
        .eraseToAnyPublisher()
}

let filmRowFailingImageLoader: (RowFilm) -> ImagePublisher = { _ in
    Fail(outputType: Image.self, failure: anyError())
        .eraseToAnyPublisher()
}

// MARK: - Detail

let filmDetailLoader: () -> AnyPublisher<DetailFilm, Error> = {
    Just(.castleInTheSky)
        .setFailureType(to: Error.self)
        .eraseToAnyPublisher()
}

let filmDetailLongLoader: () -> AnyPublisher<DetailFilm, Error> = {
    filmDetailLoader()
        .delay(for: 10, scheduler: DispatchQueue.main)
        .eraseToAnyPublisher()
}

let filmDetailLFailingLoader: () -> AnyPublisher<DetailFilm, Error> = {
    Fail(outputType: DetailFilm.self, failure: anyError())
        .eraseToAnyPublisher()
}

let filmDetailLImageLoader: (DetailFilm) -> ImagePublisher = { _ in
    Just(filmDetailImage)
        .setFailureType(to: Error.self)
        .eraseToAnyPublisher()
}

let filmDetailLLongImageLoader: (DetailFilm) -> ImagePublisher = { _ in
    Just(filmDetailImage)
        .delay(for: 10, scheduler: DispatchQueue.main)
        .setFailureType(to: Error.self)
        .eraseToAnyPublisher()
}

let filmDetailLFailingImageLoader: (DetailFilm) -> ImagePublisher = { _ in
    Fail(outputType: Image.self, failure: anyError())
        .eraseToAnyPublisher()
}

// MARK: - Helpers

private func anyError(message: String = "any error") -> Error {
    AnyError(message: message)
}

private struct AnyError: Error, LocalizedError {
    let message: String
    
    var errorDescription: String? { message }
}
