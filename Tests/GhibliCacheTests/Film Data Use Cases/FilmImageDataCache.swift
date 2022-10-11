//
//  FilmImageDataCache.swift
//  
//
//  Created by Igor Malyarov on 11.10.2022.
//

import Foundation

protocol FilmDataStore {
    func retrieve() throws -> Data?
}

final class FilmImageDataCache<Image> {
    typealias MakeImage = (Data) -> Image?
    
    private let store: FilmDataStore
    private let makeImage: MakeImage
    
    init(
        store: FilmDataStore,
        makeImage: @escaping MakeImage
    ) {
        self.store = store
        self.makeImage = makeImage
    }
    
    func load() throws -> Image? {
        let data = try store.retrieve()
        return data.map(makeImage) ?? nil
    }
}
