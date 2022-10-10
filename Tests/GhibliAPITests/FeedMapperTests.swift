//
//  File.swift
//  
//
//  Created by Igor Malyarov on 07.10.2022.
//

import GhibliDomain
import GhibliAPI
import XCTest

final class FeedMapperTests: XCTestCase {
    func test_map_throwsErrorOnNon200HTTPResponse() throws {
        let json = makeFilmsJSON([])
        let samples = [199, 201, 300, 400, 500]

        try samples.forEach { code in
            XCTAssertThrowsError(
                try FeedMapper.map(json, from: HTTPURLResponse(statusCode: code))
            )
        }
    }
    
    func test_map_throwsErrorOn200HTTPResponseWithInvalidJSON() {
        let invalidJSON = Data("invalid json".utf8)

        XCTAssertThrowsError(
            try FeedMapper.map(invalidJSON, from: HTTPURLResponse(statusCode: 200))
        )
    }

    func test_map_deliversNoItemsOn200HTTPResponseWithEmptyJSONList() throws {
        let emptyListJSON = makeFilmsJSON([])

        let result = try FeedMapper.map(emptyListJSON, from: HTTPURLResponse(statusCode: 200))

        XCTAssertEqual(result, [])
    }

    func test_map_deliversItemsOn200HTTPResponseWithJSONItems() throws {
        let item1 = makeFilm(
            id: UUID(),
            title: "title 1",
            description: "description 1",
            imageURL: URL(string: "http://an-image1-url.com")!,
            filmURL: URL(string: "http://a-film1-url.com")!
        )

        let item2 = makeFilm(
            id: UUID(),
            title: "title 2",
            description: "description 2",
            imageURL: URL(string: "http://an-image2-url.com")!,
            filmURL: URL(string: "http://a-film2-url.com")!
        )

        let json = makeFilmsJSON([item1.json, item2.json])

        let result = try FeedMapper.map(json, from: HTTPURLResponse(statusCode: 200))

        XCTAssertEqual(result, [item1.model, item2.model])
    }
    
    // MARK: - Helpers

    private func makeFilm(id: UUID, title: String, description: String, imageURL: URL, filmURL: URL) -> (model: GhibliFilm, json: [String: Any]) {
        let item = GhibliFilm(id: id, title: title, description: description, imageURL: imageURL, filmURL: filmURL)

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

        return (item, json)
    }

}
