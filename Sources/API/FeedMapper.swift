//
//  FeedMapper.swift
//  
//
//  Created by Igor Malyarov on 07.10.2022.
//

import Domain
import Foundation

public enum FeedMapper {
    private struct Film: Decodable {
        let id: UUID
        let title: String
        let original_title: String
        let original_title_romanised: String
        let image: URL
        let movie_banner: String
        let description: String
        let director: String
        let producer: String
        let release_date: String
        let running_time: String
        let rt_score: String
        let people: [String]
        let species: [String]
        let locations: [String]
        let vehicles: [String]
        let url: URL
                
        var ghibliFilm: GhibliFilm {
            .init(id: id, title: title, description: description, imageURL: image, filmURL: url)
        }
    }
    
    public static func map(_ data: Data, from response: HTTPURLResponse) throws -> [GhibliFilm] {
        guard isOK(response) else {
            throw MapError.invalidData
        }
        
        let films = try JSONDecoder().decode([Film].self, from: data)
        return films.map(\.ghibliFilm)
    }
    
    private static func isOK(_ response: HTTPURLResponse) -> Bool {
        response.statusCode == 200
    }
    public enum MapError: Error {
        case invalidData
    }
}
