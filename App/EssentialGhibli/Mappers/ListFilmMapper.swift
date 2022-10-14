//
//  ListFilmMapper.swift
//  EssentialGhibli
//
//  Created by Igor Malyarov on 14.10.2022.
//

import ListFeature
import Foundation

enum ListFilmMapper {
    static func map(dataResponse: DataResponse) throws -> [ListFilm] {
        guard dataResponse.response.is200
        else {
            throw MappingError.badResponse
        }
        
        let decoder = JSONDecoder()
        do {
            let films = try decoder.decode([DecodableFilm].self, from: dataResponse.data)
            return films.map(\.listFilm)
        } catch {
            throw MappingError.invalidData
        }
    }
    
    private struct DecodableFilm: Decodable {
        private let id: UUID
        private let title: String
        private let description: String
        private let image: URL
        private let url: URL
        
        var listFilm: ListFilm {
            .init(id: id, title: title, description: description, imageURL: image, filmURL: url)
        }
    }
}
