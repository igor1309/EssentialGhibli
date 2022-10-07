//
//  File.swift
//  
//
//  Created by Igor Malyarov on 07.10.2022.
//

import EssentialGhibliAPI
import XCTest

final class FeedMapperTests: XCTestCase {
    func test_map_throwsErrorOnNon200HTTPResponse() throws {
        let json = makeItemsJSON([])
        let samples = [199, 201, 300, 400, 500]

        try samples.forEach { code in
            XCTAssertThrowsError(
                try FeedMapper.map(json, from: HTTPURLResponse(statusCode: code))
            )
        }
    }
}
