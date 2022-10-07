//
//  FeedMapper.swift
//  
//
//  Created by Igor Malyarov on 07.10.2022.
//

import Foundation

public enum FeedMapper {
    public static func map(_ data: Data, from response: HTTPURLResponse) throws {
        throw MapError.invalidData
    }
    
    public enum MapError: Error {
        case invalidData
    }
}
