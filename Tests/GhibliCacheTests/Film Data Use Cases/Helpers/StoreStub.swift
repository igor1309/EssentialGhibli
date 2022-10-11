//
//  StoreStub.swift
//  
//
//  Created by Igor Malyarov on 11.10.2022.
//

import Foundation

final class StoreStub: FilmDataStore {
    typealias RetrievalResult = Result<Data?, Error>
    typealias InsertionResult = Result<Data?, Error>

    private var retrievalResults = [URL: RetrievalResult]()
    private var insertionResults = [URL: InsertionResult]()
    private(set) var messages = [Message]()
    
    func completeRetrieval(with result: RetrievalResult, for url: URL) {
        self.retrievalResults[url] = result
    }
    
    func retrieve(from url: URL) throws -> Data? {
        messages.append(.retrieve(url))
        return try retrievalResults[url]?.get()
    }
    
    func stubInsert(for url: URL, with result: InsertionResult) {
        insertionResults[url] = result
    }
    
    func insert(_ data: Data, for url: URL) throws {
        messages.append(.save(data, url))
        _ = try insertionResults[url]?.get()
    }
    
    enum Message: Equatable {
        case retrieve(URL)
        case save(Data, URL)
    }
}

extension StoreStub.RetrievalResult {
    static let error: Self = .failure(anyError())
    static let none: Self = .success(.none)
    static let someData: Self = .success("some data".data(using: .utf8))
}
