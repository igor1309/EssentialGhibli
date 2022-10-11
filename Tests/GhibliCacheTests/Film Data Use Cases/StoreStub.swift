//
//  StoreStub.swift
//  
//
//  Created by Igor Malyarov on 11.10.2022.
//

import Foundation

final class StoreStub: FilmDataStore {
    typealias RetrievalResult = Result<Data?, Error>

    private var retrievalResult: RetrievalResult?
    private(set) var messages = [Message]()
    
    func completeRetrieval(with result: RetrievalResult) {
        self.retrievalResult = result
    }
    
    func retrieve() throws -> Data? {
        messages.append(.retrieve)
        return try retrievalResult?.get()
    }
    
    enum Message {
        case retrieve
    }
}

extension StoreStub.RetrievalResult {
    static let error: Self = .failure(anyError())
    static let none: Self = .success(.none)
    static let someData: Self = .success("some data".data(using: .utf8))
}
