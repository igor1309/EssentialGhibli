//
//  FilmImageDataCache.swift
//  
//
//  Created by Igor Malyarov on 11.10.2022.
//

import Foundation

protocol FilmDataStore {
    func retrieve(from url: URL) throws -> Data?
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
    
    func loadImageData(from url: URL) throws -> Image? {
        let data = try store.retrieve(from: url)
        return data.map(makeImage) ?? nil
    }
}
