//
//  FilmImageDataCache.swift
//  
//
//  Created by Igor Malyarov on 11.10.2022.
//

import Foundation

protocol FilmDataStore {
    func retrieve(from url: URL) throws -> Data?
    func insert(_ data: Data, for url: URL) throws
}

final class FilmImageDataCache {
    private let store: FilmDataStore
    
    init(store: FilmDataStore) {
        self.store = store
    }
    
    func loadImageData(from url: URL) throws -> Data? {
        try store.retrieve(from: url)
    }
    
    func saveImageData(_ data: Data, for url: URL) throws {
        try store.insert(data, for: url)
    }
}
