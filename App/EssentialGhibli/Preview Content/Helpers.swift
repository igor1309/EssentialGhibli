//
//  Helpers.swift
//  EssentialGhibli
//
//  Created by Igor Malyarov on 14.10.2022.
//

import Foundation

extension Locale {
    static let en_US: Self = .init(identifier: "en-US")
    static let ru_RU: Self = .init(identifier: "ru-RU")
}

func anyError(message: String = "any error") -> Error {
    AnyError(message: message)
}

struct AnyError: Error, LocalizedError {
    let message: String
    
    var errorDescription: String? { message }
}
