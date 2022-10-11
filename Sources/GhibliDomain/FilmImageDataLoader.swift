//
//  FilmImageDataLoader.swift
//  
//
//  Created by Igor Malyarov on 11.10.2022.
//

import Foundation

public protocol FilmImageDataLoader {
    func loadImageData(from url: URL) throws -> Data
}
