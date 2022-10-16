//
//  HTTPClientStub.swift
//  EssentialGhibli
//
//  Created by Igor Malyarov on 15.10.2022.
//

import Foundation
import SharedAPI

#if DEBUG
final class HTTPClientStub: HTTPClient {
    static let online = HTTPClientStub(result: .listFilmSamples)
    static let offline = HTTPClientStub(result: .error)
    
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
    static let statusCode200: HTTPURLResponse = .init(statusCode: 200)

    convenience init(statusCode: Int) {
        self.init(url: anyURL(), statusCode: statusCode, httpVersion: nil, headerFields: nil)!
    }
}

func anyURL() -> URL {
    return URL(string: "http://any-url.com")!
}
#endif
