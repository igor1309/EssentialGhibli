//
//  FilmRowViewAdapter.swift
//  EssentialGhibli
//
//  Created by Igor Malyarov on 14.10.2022.
//

import Combine
import ListFeature
import RowFeature
import SwiftUI

struct FilmRowViewAdapter: View {
    let listFilm: ListFilm
    let imageLoader: (RowFilm) -> ImagePublisher
    
    var body: some View {
        FilmRowView(rowFilm: listFilm.rowFilm, thumbnail: thumbnail)
    }
    
    private func thumbnail(rowFilm: RowFilm) -> some View {
        LoadingImageView(showLabel: false) { imageLoader(rowFilm) }
    }
}

private extension ListFilm {
    var rowFilm: RowFilm {
        .init(id: id, title: title, description: description, imageURL: imageURL, filmURL: filmURL)
    }
}

#if DEBUG
let filmRowImage = Image(systemName: "camera.macro")

let filmRowImageLoader: (RowFilm) -> ImagePublisher = { _ in
    Just(filmRowImage)
        .setFailureType(to: Error.self)
        .eraseToAnyPublisher()
}

let filmRowLongImageLoader: (RowFilm) -> ImagePublisher = {
    filmRowImageLoader($0)
        .delay(for: 10, scheduler: DispatchQueue.main)
        .eraseToAnyPublisher()
}

let filmRowFailingImageLoader: (RowFilm) -> ImagePublisher = { _ in
    Fail(outputType: Image.self, failure: anyError())
        .eraseToAnyPublisher()
}

func filmRowViewAdapter(
    _ imageLoader: @escaping (RowFilm) -> ImagePublisher
) -> some View {
    List {
        FilmRowViewAdapter(
            listFilm: .castleInTheSky,
            imageLoader: imageLoader
        )
    }
    .listStyle(.plain)
}

struct FilmRowViewAdapter_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            filmRowViewAdapter(filmRowImageLoader)
            
            filmRowViewAdapter(filmRowLongImageLoader)
                .previewDisplayName("Long Image Loader")
            
            filmRowViewAdapter(filmRowFailingImageLoader)
                .previewDisplayName("Failing Image Loader")
        }
        .preferredColorScheme(.dark)
    }
}

private func anyError(message: String = "any error") -> Error {
    AnyError(message: message)
}

private struct AnyError: Error {
    let message: String
}
#endif
