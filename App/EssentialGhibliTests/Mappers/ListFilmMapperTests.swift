//
//  ListFilmMapperTests.swift
//  EssentialGhibliTests
//
//  Created by Igor Malyarov on 14.10.2022.
//

@testable import EssentialGhibli
import ListFeature
import XCTest

final class ListFilmMapperTests: XCTestCase {
    func test_map_shouldThrowErrorOnNon200HTTPResponse() throws {
        let json = makeListFilmsJSON([])
        let samples = [199, 201, 300, 400, 500]

        try samples.forEach { code in
            XCTAssertThrowsError(
                try ListFilmMapper.map(dataResponse: (json, .init(statusCode: code)))
            )
        }
    }
    
    func test_map_shouldThrowErrorOn200HTTPResponseWithInvalidJSON() {
        let invalidJSON = Data("invalid json".utf8)

        XCTAssertThrowsError(
            try ListFilmMapper.map(dataResponse: (invalidJSON, .statusCode200))
        ) {
            XCTAssertEqual($0 as? MappingError, .invalidData)
        }
    }

    func test_map_shouldDeliverNoItemsOn200HTTPResponseWithEmptyJSONList() throws {
        let emptyListJSON = makeListFilmsJSON([])

        let result = try ListFilmMapper.map(dataResponse: (emptyListJSON, .statusCode200))

        XCTAssertEqual(result, [])
    }

    func test_map_shouldDeliverItemsOn200HTTPResponseWithJSONItems() throws {
        let film1 = makeListFilm(
            id: UUID(),
            title: "title 1",
            description: "description 1",
            imageURL: URL(string: "http://an-image1-url.com")!,
            filmURL: URL(string: "http://a-film1-url.com")!
        )

        let film2 = makeListFilm(
            id: UUID(),
            title: "title 2",
            description: "description 2",
            imageURL: URL(string: "http://an-image2-url.com")!,
            filmURL: URL(string: "http://a-film2-url.com")!
        )

        let json = makeListFilmsJSON([film1.json, film2.json])

        let result = try ListFilmMapper.map(dataResponse: (json, .statusCode200))

        XCTAssertEqual(result, [film1.model, film2.model])
    }
    
    func test_map_shouldDeliver() throws {
        let json = [makeJSON_castleInTheSky(), makeJSON_kikisDeliveryService()]
        let data = try JSONSerialization.data(withJSONObject: json)
        
        let result = try ListFilmMapper.map(dataResponse: (data, .statusCode200))
        XCTAssertEqual(result, [.castleInTheSky, .kikisDeliveryService])
    }
    
    // MARK: - Helpers

    private func makeListFilm(id: UUID, title: String, description: String, imageURL: URL, filmURL: URL
    ) -> (
        model: ListFilm,
        json: [String: Any]
    ) {
        let film = ListFilm(id: id, title: title, description: description, imageURL: imageURL, filmURL: filmURL)

        let json: [String: Any] = [
            "id": id.uuidString,
            "title": title,
            "original_title": "火垂るの墓",
            "original_title_romanised": "Hotaru no haka",
            "image": imageURL.absoluteString,
            "movie_banner": "https://image.tmdb.org/t/p/original/vkZSd0Lp8iCVBGpFH9L7LzLusjS.jpg",
            "description": description,
            "director": "Isao Takahata",
            "producer": "Toru Hara",
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
            "url": filmURL.absoluteString
        ]

        return (film, json)
    }

}
