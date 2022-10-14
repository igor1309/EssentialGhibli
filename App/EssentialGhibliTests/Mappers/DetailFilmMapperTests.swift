//
//  DetailFilmMapperTests.swift
//  EssentialGhibliTests
//
//  Created by Igor Malyarov on 14.10.2022.
//

@testable import EssentialGhibli
import DetailFeature
import XCTest

final class DetailFilmMapperTests: XCTestCase {
    func test_map_throwsErrorOnNon200HTTPResponse() throws {
        let json = makeFilmsJSON([:])
        let codes = [199, 201, 300, 400, 500]

        try codes.forEach { code in
            XCTAssertThrowsError(
                try DetailFilmMapper.map(dataResponse: (json, .init(statusCode: code)))
            )
        }
    }
    
    func test_map_throwsErrorOn200HTTPResponseWithInvalidJSON() {
        let invalidJSON = Data("invalid json".utf8)

        XCTAssertThrowsError(
            try DetailFilmMapper.map(dataResponse: (invalidJSON, .statusCode200))
        ) {
            XCTAssertEqual($0 as? MappingError,.invalidData)
        }
    }

    func test_map_deliversDetailFilmOn200HTTPResponseWithJSON() throws {
        let film = makeDetailFilm(
            id: UUID(),
            title: "a title",
            originalTitle: "an originalTitle",
            originalTitleRomanized: "an originalTitleRomanized",
            imageURL: URL(string: "http://an-image1-url.com")!,
            description: "a description ",
            director: "a director",
            producer: "a producer"
        )

        let json = makeFilmsJSON(film.json)

        let result = try DetailFilmMapper.map(dataResponse: (json, .statusCode200))

        XCTAssertEqual(result, film.model)
    }
    
    // MARK: - Helpers

    private func makeDetailFilm(
        id: UUID,
        title: String,
        originalTitle: String,
        originalTitleRomanized: String,
        imageURL: URL,
        description: String,
        director: String,
        producer: String
    ) -> (
        model: DetailFilm,
        json: [String: Any]
    ) {
        let item = DetailFilm(
            id: id,
            title: title,
            originalTitle: originalTitle,
            originalTitleRomanized: originalTitleRomanized,
            imageURL: imageURL,
            description: description,
            director: director,
            producer: producer
        )

        let json: [String: Any] = [
            "id": id.uuidString,
            "title": title,
            "original_title": originalTitle,
            "original_title_romanised": originalTitleRomanized,
            "image": imageURL.absoluteString,
            "movie_banner": "https://image.tmdb.org/t/p/original/vkZSd0Lp8iCVBGpFH9L7LzLusjS.jpg",
            "description": description,
            "director": director,
            "producer": producer,
            "release_date": "1988",
            "running_time": "89",
            "rt_score": "97",
            "people": [
                "https://ghibliapi.herokuapp.com/people/"
            ],
            "species": [
                "https://ghibliapi.herokuapp.com/species/af3910a6-429f-4c74-9ad5-dfe1c4aa04f2"
            ],
            "locations": [
                "https://ghibliapi.herokuapp.com/locations/"
            ],
            "vehicles": [
                "https://ghibliapi.herokuapp.com/vehicles/"
            ],
            "url": "url"
        ]

        return (item, json)
    }

}
