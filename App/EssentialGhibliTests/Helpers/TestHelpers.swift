//
//  TestHelpers.swift
//  EssentialGhibliTests
//
//  Created by Igor Malyarov on 14.10.2022.
//

@testable import EssentialGhibli
import Foundation
import ListFeature
import SharedAPI

extension Locale {
    static let en_US: Self = .init(identifier: "en-US")
    static let ru_RU: Self = .init(identifier: "ru-RU")
}

func anyURL() -> URL {
    return URL(string: "http://any-url.com")!
}

private extension URL {
    static let anyURL: URL = .init(string: "https://any-url.com")!
}

func makeFilmsJSON(_ films: [String: Any]) -> Data {
    return try! JSONSerialization.data(withJSONObject: films)
}

func makeListFilmsJSON(_ films: [[String: Any]]) -> Data {
    return try! JSONSerialization.data(withJSONObject: films)
}

extension HTTPURLResponse {
    static let statusCode200: HTTPURLResponse = .init(statusCode: 200)
    static let statusCode400: HTTPURLResponse = .init(statusCode: 400)
    
    convenience init(statusCode: Int) {
        self.init(url: anyURL(), statusCode: statusCode, httpVersion: nil, headerFields: nil)!
    }
}

extension HTTPClient.HTTPResult {
    static let error: Self = .failure(anyError(message: "offline"))
    static let listFilmSamples: Self = .success((.listFilmSamples, .statusCode200))
}

extension Data {
    static let listFilmSamples: Self = try! JSONSerialization.data(withJSONObject: [
        makeJSON_castleInTheSky(),
        makeJSON_kikisDeliveryService()
    ])
}

extension HTTPURLResponse {
}

extension LoaderComposerTests.ListFilmResult {
    static let badResponse: Self = .failure(.badResponse)
    static let invalidData: Self = .failure(.invalidData)
    static let empty: Self = .success([])
    static let samples: Self = .success(.samples)
}
