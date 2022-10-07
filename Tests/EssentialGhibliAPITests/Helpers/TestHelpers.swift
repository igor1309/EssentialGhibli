//
//  TestHelpers.swift
//  
//
//  Created by Igor Malyarov on 07.10.2022.
//

import Foundation

func anyURL() -> URL {
    return URL(string: "http://any-url.com")!
}

func makeFilmsJSON(_ films: [[String: Any]]) -> Data {
    return try! JSONSerialization.data(withJSONObject: films)
}

extension HTTPURLResponse {
    convenience init(statusCode: Int) {
        self.init(url: anyURL(), statusCode: statusCode, httpVersion: nil, headerFields: nil)!
    }
}
