//
//  DetailFilmMapper.swift
//  EssentialGhibli
//
//  Created by Igor Malyarov on 14.10.2022.
//

import DetailFeature
import Foundation

enum DetailFilmMapper {
    static func map(dataResponse: DataResponse) throws -> DetailFilm {
        guard dataResponse.response.is200
        else {
            throw MappingError.badResponse
        }
        
        let decoder = JSONDecoder()
        do {
            let film = try decoder.decode(DecodableFilm.self, from: dataResponse.data)
            return film.listFilm
        } catch {
            throw MappingError.invalidData
        }
    }
    
    private struct DecodableFilm: Decodable {
        private let id: UUID
        private let title: String
        private let original_title: String
        private let original_title_romanised: String
        private let image: URL
        private let description: String
        private let director: String
        private let producer: String
        
        var listFilm: DetailFilm {
            .init(id: id, title: title, originalTitle: original_title, originalTitleRomanized: original_title_romanised, imageURL: image, description: description, director: director, producer: producer)
        }
    }
}
