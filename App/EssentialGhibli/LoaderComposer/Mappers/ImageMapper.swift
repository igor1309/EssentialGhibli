//
//  ImageMapper.swift
//  EssentialGhibli
//
//  Created by Igor Malyarov on 13.10.2022.
//

import SwiftUI

enum ImageMapper {
    static func map(dataResponse: DataResponse) throws -> Image {
        guard dataResponse.response.is200
        else {
            throw MappingError.badResponse
        }
        
        return try map(data: dataResponse.data)
    }

    static func map(data: Data) throws -> Image {
        guard
            !data.isEmpty,
            let uiImage = UIImage(data: data)
        else {
            throw MappingError.invalidData
        }
        
        return Image(uiImage: uiImage)
    }
}
