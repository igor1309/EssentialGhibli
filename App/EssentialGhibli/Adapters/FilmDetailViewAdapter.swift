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
    let listFilm: ListFilm
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
        listFilm: .castleInTheSky,
        loader: loader,
        imageLoader: imageLoader
    )
}

struct FilmDetailViewAdapter_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            filmDetailViewAdapter(
                loader: filmDetailLoader,
                imageLoader: filmDetailLImageLoader
            )
            
            filmDetailViewAdapter(
                loader: filmDetailLongLoader,
                imageLoader: filmDetailLImageLoader
            )
            .environment(\.locale, .en_US)
            .previewDisplayName("en-US | Long Loader")
            
            filmDetailViewAdapter(
                loader: filmDetailLongLoader,
                imageLoader: filmDetailLImageLoader
            )
            .environment(\.locale, .ru_RU)
            .previewDisplayName("ru-RU | Long Loader")
            
            filmDetailViewAdapter(
                loader: filmDetailLFailingLoader,
                imageLoader: filmDetailLImageLoader
            )
            .previewDisplayName("Failing Loader")
            
            filmDetailViewAdapter(
                loader: filmDetailLoader,
                imageLoader: filmDetailLLongImageLoader
            )
            .previewDisplayName("Long Image Loader")
            
            filmDetailViewAdapter(
                loader: filmDetailLoader,
                imageLoader: filmDetailLFailingImageLoader
            )
            .previewDisplayName("Failing Image Loader")
            
        }
        .preferredColorScheme(.dark)
    }
}
#endif
