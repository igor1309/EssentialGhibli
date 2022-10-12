//
//  File.swift
//  
//
//  Created by Igor Malyarov on 07.10.2022.
//

import Foundation

public enum FeedEndpoint {
    case films
    case film(filmID: String)
    
    public func url(baseURL: URL) -> URL {
        switch self {
        case .films:
            return baseURL.appendingPathComponent("/films")
            
        case let .film(filmID):
            return baseURL.appendingPathComponent("/films/\(filmID)")
        }
    }
}
