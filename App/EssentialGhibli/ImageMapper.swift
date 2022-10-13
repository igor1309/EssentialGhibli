//
//  ImageMapper.swift
//  EssentialGhibli
//
//  Created by Igor Malyarov on 13.10.2022.
//

import SwiftUI

enum ImageMapper {
    static func map(dataResponse: DataResponse) throws -> Image {
        guard isOK(response: dataResponse.response)
        else {
            throw MappingError.badResponse
        }
        
        guard let uiImage = UIImage(data: dataResponse.data)
        else {
            throw MappingError.invalidData
        }
        
        return Image(uiImage: uiImage)
    }
    
    private static func isOK(response: HTTPURLResponse) -> Bool {
        response.statusCode == 200
    }
    
    enum MappingError: String, Error, LocalizedError {
        case badResponse
        case invalidData
        
        var errorDescription: String? {
            rawValue
        }
    }
}
