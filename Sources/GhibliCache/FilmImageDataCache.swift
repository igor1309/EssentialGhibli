//
//  FilmImageDataCache.swift
//  
//
//  Created by Igor Malyarov on 11.10.2022.
//

import GhibliDomain
import Foundation

public protocol FilmDataStore {
    func retrieve(from url: URL) throws -> Data?
    func insert(_ data: Data, for url: URL) throws
}

public final class FilmImageDataCache {
    private let store: FilmDataStore
    
    public init(store: FilmDataStore) {
        self.store = store
    }
}

extension FilmImageDataCache: FilmImageDataLoader {
    public func loadImageData(from url: URL) throws -> Data {
        let result = Result { try store.retrieve(from: url) }
        
        switch result {
        case let .success(data):
            if let data {
                return data
            } else {
                throw LoadError.notFound
            }
            
        case .failure:
            throw LoadError.failed
        }
    }
    
    public enum LoadError: Error {
        case failed
        case notFound
    }
}

extension FilmImageDataCache: FilmImageDataSaver {
    public func saveImageData(_ data: Data, for url: URL) throws {
        do {
            try store.insert(data, for: url)
        } catch {
            throw SaveError.failed
        }
    }
    
    public enum SaveError: Error {
        case failed
    }
}
