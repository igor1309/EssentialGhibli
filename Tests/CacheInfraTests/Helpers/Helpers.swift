//
//  Helpers.swift
//  
//
//  Created by Igor Malyarov on 10.10.2022.
//

import Cache
import CacheInfra
import Foundation

func uniqueFilmFeed() -> [LocalFilm] {
    [makeLocalFilm(), makeLocalFilm()]
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

extension Data {
    static let anyData = Data("any data".utf8)
    static let anotherData = Data("another data".utf8)
}
