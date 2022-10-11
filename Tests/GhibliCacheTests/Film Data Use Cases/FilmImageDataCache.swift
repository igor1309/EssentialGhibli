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

final class FilmImageDataCache<Image> {
    typealias MakeImage = (Data) -> Image?
    typealias MakeData = (Image) -> Data?

    private let store: FilmDataStore
    private let makeImage: MakeImage
    private let makeData: MakeData
    
    init(
        store: FilmDataStore,
        makeImage: @escaping MakeImage,
        makeData: @escaping MakeData
    ) {
        self.store = store
        self.makeImage = makeImage
        self.makeData = makeData
    }
    
    func loadImageData(from url: URL) throws -> Image? {
        let data = try store.retrieve(from: url)
        return data.map(makeImage) ?? nil
    }
    
    func saveImageData(_ image: Image, for url: URL) throws {
        guard let data = makeData(image) else { return }
        
        try store.insert(data, for: url)
    }
}
