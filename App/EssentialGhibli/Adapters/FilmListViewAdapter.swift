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
func filmListViewAdapter(
    _ listFilmsLoader: @escaping () -> AnyPublisher<[ListFilm], Error>
) -> some View {
    FilmListViewAdapter(
        filmsLoader: listFilmsLoader,
        filmRow: { Text($0.title) }
    )
}

struct FilmListViewAdapter_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            filmListViewAdapter(LoaderComposer.online.filmsLoader)
            
            filmListViewAdapter(LoaderComposer.offline.filmsLoader)
                .environment(\.locale, .en_US)
                .previewDisplayName("en-US | Empty List Loader")
            
            filmListViewAdapter(LoaderComposer.offline.filmsLoader)
                .environment(\.locale, .ru_RU)
                .previewDisplayName("ru-RU | Empty List Loader")
            
            filmListViewAdapter(LoaderComposer.online.longFilmsLoader)
                .environment(\.locale, .en_US)
                .previewDisplayName("en-US | Long List Loader")
            
            filmListViewAdapter(LoaderComposer.online.longFilmsLoader)
                .environment(\.locale, .ru_RU)
                .previewDisplayName("ru-RU Long List Loader")
            
            filmListViewAdapter(PreviewLoaders.failingListFilmsLoader)
                .previewDisplayName("Failing List Loader")
        }
        .preferredColorScheme(.dark)
    }
}
#endif
