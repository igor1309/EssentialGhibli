//
//  FeedEndpointTests.swift
//  
//
//  Created by Igor Malyarov on 07.10.2022.
//

import GhibliAPI
import XCTest

final class FeedEndpointTests: XCTestCase {
    func test_feed_endpointURL() {
        let baseURL = URL(string: "http://base-url.com")!

        let received = FeedEndpoint.films.url(baseURL: baseURL)
        let expected = URL(string: "http://base-url.com/films")!

        XCTAssertEqual(received, expected)
    }
}
