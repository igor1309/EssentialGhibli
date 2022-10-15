//
//  MappingError.swift
//  EssentialGhibli
//
//  Created by Igor Malyarov on 14.10.2022.
//

import Foundation

public enum MappingError: String, Error, LocalizedError, Equatable {
    case badResponse
    case invalidData
    
    public var errorDescription: String? {
        rawValue
    }
}
