//
//  HTTPClientStub.swift
//  EssentialGhibli
//
//  Created by Igor Malyarov on 15.10.2022.
//

import Foundation
import SharedAPI
import UIKit

#if DEBUG
final class HTTPClientStub: HTTPClient {
    private class Task: HTTPClientTask {
        func cancel() {}
    }
    
    private let stub: (URL) -> HTTPResult
    
    init(stub: @escaping (URL) -> HTTPResult) {
        self.stub = stub
    }
    
    func get(
        from url: URL,
        completion: @escaping (HTTPResult) -> Void
    ) -> HTTPClientTask {
        completion(stub(url))
        return Task()
    }
}

extension HTTPClientStub {
    static var offline: HTTPClientStub {
        .init { _ in .error }
    }
    
    static func online(_ stub: @escaping (URL) -> DataResponse) -> HTTPClientStub {
        .init { url in .success(stub(url)) }
    }
}

func response200(for url: URL) -> DataResponse {
    return (makeData(for: url), .statusCode200)
}

func makeData(for url: URL) -> Data {
    switch url.path() {
    case "/films":
        return .listFilmSamples
        
    case "/t/p/w600_and_h900_bestv2/npOnzAbLh6VOIu3naU5QaEcTepo.jpg":
        return .uiImageData(withColor: .orange, width: 30, height: 40)
        
    case "/t/p/w600_and_h900_bestv2/7nO5DUMnGUuXrA4r2h6ESOKQRrx.jpg":
        return .uiImageData(withColor: .red, width: 30, height: 40)
        
    case "/films/2baf70d1-42bb-4437-b551-e5fed5a87abe":
        return .castleInTheSky
        
    case "/films/ea660b10-85c4-4ae3-8a5f-41cea3648e3e":
        return .kikisDeliveryService
        
    default: return Data()
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
    
    static let castleInTheSky: Self = try! JSONSerialization.data(withJSONObject: makeJSON_castleInTheSky())
    static let kikisDeliveryService: Self = try! JSONSerialization.data(withJSONObject: makeJSON_kikisDeliveryService())
    
}
#endif
