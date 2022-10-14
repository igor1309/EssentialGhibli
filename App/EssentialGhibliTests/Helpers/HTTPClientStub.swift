//
//  HTTPClientStub.swift
//  EssentialGhibliTests
//
//  Created by Igor Malyarov on 15.10.2022.
//

import Foundation
import SharedAPI

final class HTTPClientStub: HTTPClient {
    static let offline = HTTPClientStub(result: .error)
    static let online = HTTPClientStub(result: .listFilmSamples)
    
    private let result: HTTPResult
    
    init(result: HTTPResult) {
        self.result = result
    }
    
    private class ClientTask: HTTPClientTask {
        func cancel() {}
    }
    
    func get(
        from url: URL, completion: @escaping (HTTPResult) -> Void
    ) -> HTTPClientTask {
        completion(result)
        return ClientTask()
    }
}
