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
    public let image: URL
    public let film: URL
    
    public init(id: UUID, title: String, description: String, image: URL, film: URL) {
        self.id = id
        self.title = title
        self.description = description
        self.image = image
        self.film = film
    }
}
