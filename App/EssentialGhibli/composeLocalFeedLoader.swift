//
//  composeLocalFeedLoader.swift
//  EssentialGhibli
//
//  Created by Igor Malyarov on 10.10.2022.
//

import GhibliDomain
import GhibliCache
import GhibliCacheInfra
import Foundation

func composeLocalFeedLoader () {
    let storeURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        .appendingPathComponent("feed-store.store")
    let store = CodableFeedStore(storeURL: storeURL)
    let loader = LocalFeedLoader(
        store: store,
        toLocal: LocalFilm.init(film:),
        fromLocal: GhibliFilm.init(local:)
    )
}

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
