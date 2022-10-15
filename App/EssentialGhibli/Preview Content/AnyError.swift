//
//  AnyError.swift
//  EssentialGhibli
//
//  Created by Igor Malyarov on 14.10.2022.
//

import Foundation

func anyError(message: String = "any error") -> Error {
    AnyError(message: message)
}

struct AnyError: Error, LocalizedError {
    let message: String
    
    var errorDescription: String? { message }
}
