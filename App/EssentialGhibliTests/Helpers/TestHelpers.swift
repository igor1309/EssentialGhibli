//
//  TestHelpers.swift
//
//
//  Created by Igor Malyarov on 14.10.2022.
//

@testable import EssentialGhibli
import Foundation
import ListFeature
import SharedAPI

func makeFilmsJSON(_ films: [String: Any]) -> Data {
    return try! JSONSerialization.data(withJSONObject: films)
}

func makeListFilmsJSON(_ films: [[String: Any]]) -> Data {
    return try! JSONSerialization.data(withJSONObject: films)
}

extension HTTPURLResponse {
    static let statusCode400: HTTPURLResponse = .init(statusCode: 400)
}

extension LoaderComposerTests.ListFilmResult {
    static let badResponse: Self = .failure(.badResponse)
    static let invalidData: Self = .failure(.invalidData)
    static let empty: Self = .success([])
    static let samples: Self = .success(.samples)
}
