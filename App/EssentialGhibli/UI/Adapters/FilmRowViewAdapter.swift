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
        LoadingImageView(
            contentMode: .fit,
            showLabel: false
        ) { imageLoader(rowFilm) }
            .frame(width: 60, height: 90)
            .clipped()
    }
}

private extension ListFilm {
    var rowFilm: RowFilm {
        .init(id: id, title: title, description: description, imageURL: imageURL, filmURL: filmURL)
    }
}

#if DEBUG
func filmRowViewAdapter(_ loaderComposer: LoaderComposer) -> some View {
    filmRowViewAdapter(loaderComposer.filmRowImageLoader(rowFilm:))
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
            filmRowViewAdapter(PreviewLoaders.filmRowImageLoader)
            
            filmRowViewAdapter(LoaderComposer.online)
            
            filmRowViewAdapter(PreviewLoaders.longFilmRowImageLoader)
                .previewDisplayName("Long Image Loader")
            
            filmRowViewAdapter(PreviewLoaders.failingFilmRowImageLoader)
                .previewDisplayName("Failing Image Loader")
        }
        .preferredColorScheme(.dark)
    }
}
#endif
