//
//  FilmListViewAdapter.swift
//  EssentialGhibli
//
//  Created by Igor Malyarov on 14.10.2022.
//

import Combine
import GenericResourceView
import ListFeature
import SwiftUI

struct FilmListViewAdapter<Row: View>: View {
    let filmsLoader: () -> AnyPublisher<[ListFilm], Error>
    let filmRow: (ListFilm) -> Row
    
    var body: some View {
        LoadResourceView(
            viewModel: .init(loader: filmsLoader),
            resourceView: filmListView,
            loadingView: ProgressLoadingView.init,
            errorView: ErrorView.init
        )
    }
    
    private func filmListView(listFilms: [ListFilm]) -> some View {
        FilmListView(films: listFilms, filmRow: filmRow)
    }
    
}

#if DEBUG
let filmsLoader: () -> AnyPublisher<[ListFilm], Error> = {
    Just(.samples)
        .setFailureType(to: Error.self)
        .eraseToAnyPublisher()
}

let emptyFilmsLoader: () -> AnyPublisher<[ListFilm], Error> = {
    Just([])
        .setFailureType(to: Error.self)
        .eraseToAnyPublisher()
}

let longFilmsLoader: () -> AnyPublisher<[ListFilm], Error> = {
    emptyFilmsLoader()
        .delay(for: 10, scheduler: DispatchQueue.main)
        .eraseToAnyPublisher()
}

let failingFilmsLoader: () -> AnyPublisher<[ListFilm], Error> = {
    Fail(outputType: [ListFilm].self, failure: anyError())
        .eraseToAnyPublisher()
}

func filmListViewAdapter(
    _ filmsLoader: @escaping () -> AnyPublisher<[ListFilm], Error>
) -> some View {
    FilmListViewAdapter(
        filmsLoader: filmsLoader,
        filmRow: { Text($0.title) }
    )
}

struct FilmListViewAdapter_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            filmListViewAdapter(filmsLoader)
            
            filmListViewAdapter(emptyFilmsLoader)
                .previewDisplayName("Empty List Loader")
            
            filmListViewAdapter(emptyFilmsLoader)
                .previewDisplayName("Long List Loader")
            
            filmListViewAdapter(failingFilmsLoader)
                .previewDisplayName("Failing List Loader")
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
