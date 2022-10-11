//
//  Helpers.swift
//  
//
//  Created by Igor Malyarov on 11.10.2022.
//

import Foundation

extension URL {
    static let anyURL: Self = .init(string: "any://url")!
    static let otherURL: Self = .init(string: "any://other.url")!
}

func imageData(image: String = "Some data here") -> (image: String, data: Data) {
    let data = image.data(using: .utf8)!
    
    return (image, data)
}
