//
//  FilmDetailViewAdapter.swift
//  EssentialGhibli
//
//  Created by Igor Malyarov on 14.10.2022.
//

import Combine
import DetailFeature
import GenericResourceView
import ListFeature
import SwiftUI

struct FilmDetailViewAdapter: View {
    let loader: () -> AnyPublisher<DetailFilm, Error>
    let imageLoader: (DetailFilm) -> ImagePublisher
    
    var body: some View {
        LoadResourceView(
            viewModel: .init(loader: loader),
            resourceView: filmDetailView,
            loadingView: ProgressLoadingView.init,
            errorView: ErrorView.init
        )
    }
    
    private func filmDetailView(film: DetailFilm) -> some View {
        FilmDetailView(film: film, poster: poster)
    }
    
    private func poster(detailFilm: DetailFilm) -> some View {
        Color.clear
            .aspectRatio(1, contentMode: .fit)
            .overlay {
                LoadingImageView { imageLoader(detailFilm) }
            }
    }
}

#if DEBUG
func filmDetailViewAdapter(
    loader: @escaping () -> AnyPublisher<DetailFilm, Error>,
    imageLoader: @escaping (DetailFilm) -> ImagePublisher
) -> some View {
    FilmDetailViewAdapter(
        loader: loader,
        imageLoader: imageLoader
    )
}

struct FilmDetailViewAdapter_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            filmDetailViewAdapter(
                loader: PreviewLoaders.detailFilmLoader,
                imageLoader: PreviewLoaders.detailFilmImageLoader
            )
            
            filmDetailViewAdapter(
                loader: PreviewLoaders.filmDetailLongLoader,
                imageLoader: PreviewLoaders.detailFilmImageLoader
            )
            .environment(\.locale, .en_US)
            .previewDisplayName("en-US | Long Loader")
            
            filmDetailViewAdapter(
                loader: PreviewLoaders.filmDetailLongLoader,
                imageLoader: PreviewLoaders.detailFilmImageLoader
            )
            .environment(\.locale, .ru_RU)
            .previewDisplayName("ru-RU | Long Loader")
            
            filmDetailViewAdapter(
                loader: PreviewLoaders.failingDetailFilmLoader,
                imageLoader: PreviewLoaders.detailFilmImageLoader
            )
            .previewDisplayName("Failing Loader")
            
            filmDetailViewAdapter(
                loader: PreviewLoaders.detailFilmLoader,
                imageLoader: PreviewLoaders.longDetailFilmImageLoader
            )
            .previewDisplayName("Long Image Loader")
            
            filmDetailViewAdapter(
                loader: PreviewLoaders.detailFilmLoader,
                imageLoader: PreviewLoaders.failingDetailFilmImageLoader
            )
            .previewDisplayName("Failing Image Loader")
            
        }
        .preferredColorScheme(.dark)
    }
}
#endif
