//
//  HTTPURLResponse+is200.swift
//  EssentialGhibli
//
//  Created by Igor Malyarov on 14.10.2022.
//

import Foundation

extension HTTPURLResponse {
    var is200: Bool {
        statusCode == 200
    }
}
