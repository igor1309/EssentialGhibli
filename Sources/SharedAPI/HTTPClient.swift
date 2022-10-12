//
//  HTTPClient.swift
//  
//
//  Created by Igor Malyarov on 07.10.2022.
//

import Foundation

public protocol HTTPClientTask {
    func cancel()
}

public protocol HTTPClient {
    typealias HTTPResult = Result<(Data, HTTPURLResponse), Error>
    
    @discardableResult
    func get(from url: URL, completion: @escaping (HTTPResult) -> Void) -> HTTPClientTask
}
