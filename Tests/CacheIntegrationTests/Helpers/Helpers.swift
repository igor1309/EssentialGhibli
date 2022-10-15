//
//  Helpers.swift
//  
//
//  Created by Igor Malyarov on 11.10.2022.
//

import Domain
import Cache
import CacheInfra
import Foundation

extension GhibliFilm {
    init(local: LocalFilm) {
        self.init(
            id: local.id,
            title: local.title,
            description: local.description,
            imageURL: local.imageURL,
            filmURL: local.filmURL
        )
    }
}

extension LocalFilm {
    init(film: GhibliFilm) {
        self.init(
            id: film.id,
            title: film.title,
            description: film.description,
            imageURL: film.imageURL,
            filmURL: film.filmURL
        )
    }
}

func uniqueFilmFeed() -> (feed: [GhibliFilm], local: [LocalFilm]) {
    let local = [makeLocalFilm(), makeLocalFilm()]
    return (local.map(GhibliFilm.init(local:)), local)
}

func makeLocalFilm() -> LocalFilm {
    .init(
        id: UUID(),
        title: "a title",
        description: "a description",
        imageURL: URL(string: "any-url")!,
        filmURL: URL(string: "any-url")!
    )
}

struct AnyError: Error, Equatable {}

func anyError() -> Error {
    AnyError()
}
