//
//  FilmImageDataStore.swift
//  
//
//  Created by Igor Malyarov on 12.10.2022.
//

import Foundation

public protocol FilmImageDataStore {
    func retrieve(dataForURL url: URL) throws -> Data?
    func insert(_ data: Data, for url: URL) throws
}
