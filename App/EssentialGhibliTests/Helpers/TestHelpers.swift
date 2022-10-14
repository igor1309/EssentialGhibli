//
//  TestHelpers.swift
//  EssentialGhibliTests
//
//  Created by Igor Malyarov on 14.10.2022.
//

import Foundation

extension Locale {
    static let en_US: Self = .init(identifier: "en-US")
    static let ru_RU: Self = .init(identifier: "ru-RU")
}

func anyURL() -> URL {
    return URL(string: "http://any-url.com")!
}

func makeFilmsJSON(_ films: [String: Any]) -> Data {
    return try! JSONSerialization.data(withJSONObject: films)
}

func makeListFilmsJSON(_ films: [[String: Any]]) -> Data {
    return try! JSONSerialization.data(withJSONObject: films)
}

extension HTTPURLResponse {
    static let statusCode200: HTTPURLResponse = .init(statusCode: 200)
    
    convenience init(statusCode: Int) {
        self.init(url: anyURL(), statusCode: statusCode, httpVersion: nil, headerFields: nil)!
    }
}
