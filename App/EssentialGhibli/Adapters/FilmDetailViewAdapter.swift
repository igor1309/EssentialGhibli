//
//  FilmDetailViewAdapter.swift
//  EssentialGhibli
//
//  Created by Igor Malyarov on 14.10.2022.
//

import Combine
import DetailFeature
import GenericResourceView
import Presentation
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
let filmDetailmage = Image(systemName: "camera.macro")

let filmDetailLoader: () -> AnyPublisher<DetailFilm, Error> = {
    Just(.castleInTheSky)
        .setFailureType(to: Error.self)
        .eraseToAnyPublisher()
}

let filmDetailLongLoader: () -> AnyPublisher<DetailFilm, Error> = {
    filmDetailLoader()
        .delay(for: 10, scheduler: DispatchQueue.main)
        .eraseToAnyPublisher()
}

let filmDetailLFailingLoader: () -> AnyPublisher<DetailFilm, Error> = {
    Fail(outputType: DetailFilm.self, failure: anyError())
        .eraseToAnyPublisher()
}

let filmDetailLImageLoader: (DetailFilm) -> ImagePublisher = { _ in
    Just(filmDetailmage)
        .setFailureType(to: Error.self)
        .eraseToAnyPublisher()
}

let filmDetailLLongImageLoader: (DetailFilm) -> ImagePublisher = { _ in
    Just(filmDetailmage)
        .delay(for: 10, scheduler: DispatchQueue.main)
        .setFailureType(to: Error.self)
        .eraseToAnyPublisher()
}

let filmDetailLFailingImageLoader: (DetailFilm) -> ImagePublisher = { _ in
    Fail(outputType: Image.self, failure: anyError())
        .eraseToAnyPublisher()
}

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
            .previewDisplayName("Long Loader")
            
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

private func anyError(message: String = "any error") -> Error {
    AnyError(message: message)
}

private struct AnyError: Error, LocalizedError {
    let message: String
    
    var errorDescription: String? { message }
}
#endif
