//
//  PreviewContent.swift
//  
//
//  Created by Igor Malyarov on 06.10.2022.
//

import SwiftUI

#if DEBUG
public extension Array where Element == GhibliListFilm {
    static let samples: Self = [.castleInTheSky, .kikisDeliveryService]
}

public extension GhibliListFilm {
    static let castleInTheSky: Self = .init(
        id: UUID(uuidString: "2baf70d1-42bb-4437-b551-e5fed5a87abe")!,
        title: "Castle in the Sky",
        description: "The orphan Sheeta inherited a mysterious crystal that links her to the mythical sky-kingdom of Laputa. With the help of resourceful Pazu and a rollicking band of sky pirates, she makes her way to the ruins of the once-great civilization. Sheeta and Pazu must outwit the evil Muska, who plans to use Laputa's science to make himself ruler of the world.",
        imageURL: URL(string: "https://image.tmdb.org/t/p/w600_and_h900_bestv2/npOnzAbLh6VOIu3naU5QaEcTepo.jpg")!,
        filmURL: URL(string: "https://ghibliapi.herokuapp.com/films/2baf70d1-42bb-4437-b551-e5fed5a87abe")!
    )
    
    static let kikisDeliveryService: Self = .init(
        id: UUID(uuidString: "ea660b10-85c4-4ae3-8a5f-41cea3648e3e")!,
        title: "Kiki's Delivery Service",
        description: "A young witch, on her mandatory year of independent life, finds fitting into a new community difficult while she supports herself by running an air courier service.",
        imageURL: URL(string: "https://image.tmdb.org/t/p/w600_and_h900_bestv2/7nO5DUMnGUuXrA4r2h6ESOKQRrx.jpg")!,
        filmURL: URL(string: "https://ghibliapi.herokuapp.com/films/ea660b10-85c4-4ae3-8a5f-41cea3648e3e")!
    )
}
#endif
