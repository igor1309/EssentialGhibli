//
//  Helpers.swift
//  
//
//  Created by Igor Malyarov on 11.10.2022.
//

import GhibliDomain
import GhibliCacheInfra

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
