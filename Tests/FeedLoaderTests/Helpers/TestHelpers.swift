//
//  TestHelpers.swift
//  
//
//  Created by Igor Malyarov on 09.10.2022.
//

import Foundation

func anyError() -> Error {
    AnyError()
}

struct AnyError: Error, Equatable {}
