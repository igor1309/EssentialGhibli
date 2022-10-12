//
//  GhibliDetailFilm.swift
//  
//
//  Created by Igor Malyarov on 07.10.2022.
//

import Foundation

public struct GhibliDetailFilm: Identifiable, Hashable {
    public let id: UUID
    public let title: String
    public let originalTitle: String
    public let originalTitleRomanized: String
    public let imageURL: URL
    public let description: String
    public let director: String
    public let producer: String
    
    init(
        id: UUID,
        title: String,
        originalTitle: String,
        originalTitleRomanized: String,
        imageURL: URL,
        description: String,
        director: String,
        producer: String
    ) {
        self.id = id
        self.title = title
        self.originalTitle = originalTitle
        self.originalTitleRomanized = originalTitleRomanized
        self.imageURL = imageURL
        self.description = description
        self.director = director
        self.producer = producer
    }
}
