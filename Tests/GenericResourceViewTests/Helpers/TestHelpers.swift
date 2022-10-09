//
//  TestHelpers.swift
//  
//
//  Created by Igor Malyarov on 09.10.2022.
//

import Foundation

extension Locale {
    static let en_US: Self = .init(identifier: "en-US")
    static let ru_RU: Self = .init(identifier: "ru-RU")
}

func anyError(message: String = "any error") -> AnyError {
    .init(message: message)
}

struct AnyError: Error {
    let message: String
}
