//
//  PreviewContent.swift
//  
//
//  Created by Igor Malyarov on 06.10.2022.
//

import SwiftUI

#if DEBUG
public extension DetailFilm {
    static let castleInTheSky: Self = .init(
        id: UUID(uuidString: "2baf70d1-42bb-4437-b551-e5fed5a87abe")!,
        title: "Castle in the Sky",
        originalTitle: "天空の城ラピュタ",
        originalTitleRomanized: "Tenkū no shiro Rapyuta",
        imageURL: URL(string: "https://image.tmdb.org/t/p/w600_and_h900_bestv2/npOnzAbLh6VOIu3naU5QaEcTepo.jpg")!,
        description: "The orphan Sheeta inherited a mysterious crystal that links her to the mythical sky-kingdom of Laputa. With the help of resourceful Pazu and a rollicking band of sky pirates, she makes her way to the ruins of the once-great civilization. Sheeta and Pazu must outwit the evil Muska, who plans to use Laputa's science to make himself ruler of the world.",
        director: "Hayao Miyazaki",
        producer: "Isao Takahata"
    )
}
#endif
