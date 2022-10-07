//
//  GhibliListItem.swift
//  
//
//  Created by Igor Malyarov on 06.10.2022.
//

import Foundation

public struct GhibliListItem: Identifiable, Hashable {
    public let id: UUID
    public let title: String
    public let description: String
    public let imageURL: URL
    public let filmURL: URL
    
    public init(id: UUID, title: String, description: String, imageURL: URL, filmURL: URL) {
        self.id = id
        self.title = title
        self.description = description
        self.imageURL = imageURL
        self.filmURL = filmURL
    }
}
