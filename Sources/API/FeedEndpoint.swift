//
//  FeedEndpoint.swift
//  
//
//  Created by Igor Malyarov on 07.10.2022.
//

import Foundation

public enum FeedEndpoint {
    case films
    case film(filmID: UUID)
    
    public func url(baseURL: URL) -> URL {
        switch self {
        case .films:
            return baseURL.appendingPathComponent("/films")
            
        case let .film(filmID):
            let filmIDString = filmID.uuidString.lowercased()
            return baseURL.appendingPathComponent("/films/\(filmIDString)")
        }
    }
}
