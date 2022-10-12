//
//  TestHelpers.swift
//  
//
//  Created by Igor Malyarov on 12.10.2022.
//

import Foundation

func anyError(message: String = "any error") -> Error {
    AnyError(message: message)
}

struct AnyError: Error {
    let message: String
}

extension AnyError: LocalizedError {
    var errorDescription: String? {
        return message
    }
}
