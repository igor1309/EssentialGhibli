//
//  HTTPURLResponse+ext.swift
//  
//
//  Created by Igor Malyarov on 16.10.2022.
//

import Foundation

#if DEBUG
extension HTTPURLResponse {
    static let statusCode200: HTTPURLResponse = .init(statusCode: 200)
    static let statusCode400: HTTPURLResponse = .init(statusCode: 400)
    
    convenience init(statusCode: Int) {
        self.init(url: anyURL(), statusCode: statusCode, httpVersion: nil, headerFields: nil)!
    }
}

func anyURL() -> URL {
    return URL(string: "http://any-url.com")!
}
#endif
