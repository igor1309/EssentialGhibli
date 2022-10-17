//
//  FeedEndpointTests.swift
//  
//
//  Created by Igor Malyarov on 07.10.2022.
//

import API
import XCTest

final class FeedEndpointTests: XCTestCase {
    func test_feed_endpointURL() {
        let baseURL = URL(string: "http://base-url.com")!

        let received = FeedEndpoint.films.url(baseURL: baseURL)
        let expected = URL(string: "http://base-url.com/films")!

        XCTAssertEqual(received, expected)
    }
    
    func test_film_endpointURL() {
        let baseURL = URL(string: "http://base-url.com")!

        let filmID = UUID(uuidString: "2BAF70D1-42BB-4437-B551-E5FED5A87ABE")!
        let received = FeedEndpoint.film(filmID: filmID).url(baseURL: baseURL)
        let expected = URL(string: "http://base-url.com/films/2baf70d1-42bb-4437-b551-e5fed5a87abe")!

        XCTAssertEqual(received, expected)
    }
    
    func test_film_endpointURL2() {
        let baseURL = URL(string: "http://base-url.com")!

        let filmID = UUID(uuidString: "2baf70d1-42bb-4437-b551-e5fed5a87abe")!
        let received = FeedEndpoint.film(filmID: filmID).url(baseURL: baseURL)
        let expected = URL(string: "http://base-url.com/films/2baf70d1-42bb-4437-b551-e5fed5a87abe")!

        XCTAssertEqual(received, expected)
    }
}
