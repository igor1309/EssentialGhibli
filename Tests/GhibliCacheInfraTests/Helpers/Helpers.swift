//
//  Helpers.swift
//  
//
//  Created by Igor Malyarov on 10.10.2022.
//

import Foundation

struct AnyError: Error, Equatable {}

func anyError() -> Error {
    AnyError()
}
