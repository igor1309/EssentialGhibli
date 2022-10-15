//
//  LocalFilm+ListFilm.swift
//  EssentialGhibliTests
//
//  Created by Igor Malyarov on 15.10.2022.
//

import Cache
import ListFeature

extension ListFilm {
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

extension LocalFilm {
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

