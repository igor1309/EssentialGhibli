//
//  FilmImageDataCache.swift
//  
//
//  Created by Igor Malyarov on 11.10.2022.
//

import Foundation

public protocol FilmImageDataSaver {
    func saveImageData(_ data: Data, for url: URL) throws
}
