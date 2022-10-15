//
//  TestHelpers.swift
//  
//
//  Created by Igor Malyarov on 09.10.2022.
//

import Cache
import Foundation

struct TestFilm: Identifiable, Hashable {
    let id: UUID
    let title: String
    let description: String
    let imageURL: URL
    let filmURL: URL
    
    init(id: UUID, title: String, description: String, imageURL: URL, filmURL: URL) {
        self.id = id
        self.title = title
        self.description = description
        self.imageURL = imageURL
        self.filmURL = filmURL
    }
}

func uniqueItemFeed() -> (testFilms: [TestFilm], local: [LocalFilm]) {
    let uniqueItems = (0...9).map { _ in makeUniqueItem() }
    return (uniqueItems, uniqueItems.map(toLocal))
}

func makeUniqueItem() -> TestFilm {
    .init(
        id: UUID(),
        title: "a title",
        description: "a description",
        imageURL: .anyURL,
        filmURL: .anyURL
    )
}

func toLocal(_ testFilm: TestFilm) -> LocalFilm {
    .init(listFilm: testFilm)
}

func fromLocal(_ localFilm: LocalFilm) -> TestFilm {
    .init(localFilm: localFilm)
}

func anyError() -> Error {
    AnyError()
}

struct AnyError: Error, Equatable {}

extension TestFilm {
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
    init(listFilm: TestFilm) {
        self.init(
            id: listFilm.id,
            title: listFilm.title,
            description: listFilm.description,
            imageURL: listFilm.imageURL,
            filmURL: listFilm.filmURL
        )
    }
}

