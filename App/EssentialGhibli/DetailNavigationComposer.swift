//
//  DetailNavigationComposer.swift
//  EssentialGhibli
//
//  Created by Igor Malyarov on 14.10.2022.
//

import Combine
import ListFeature
import SwiftUI

/// Wrapping this component in the navigation stack and providing the navigation title is the responsibility of the caller
struct DetailNavigationComposer<FilmRow, FilmDetail>: View
where FilmRow: View,
      FilmDetail: View {
    
    let filmsLoader: () -> AnyPublisher<[ListFilm], Error>
    let filmRow: (ListFilm) -> FilmRow
    let filmDetail: (ListFilm) -> FilmDetail
    
    var body: some View {
        FilmListViewAdapter(filmsLoader: filmsLoader, filmRow: navigationLink)
    }
    
    private func navigationLink(listFilm: ListFilm) -> some View {
        NavigationLink {
            filmDetail(listFilm)
                .navigationTitle(listFilm.title)
        } label: {
            filmRow(listFilm)
        }
    }
}

#if DEBUG
func detailNavigationComposer(
    _ listFilmsLoader: @escaping () -> AnyPublisher<[ListFilm], Error>
) -> some View {
    DetailNavigationComposer(
        filmsLoader: listFilmsLoader,
        filmRow: { Text($0.title) },
        filmDetail: { Text("Detail view for \($0.title)") }
    )
}

struct DetailNavigationComposer_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                detailNavigationComposer(PreviewLoaders.listFilmsLoader)
            }
            
            detailNavigationComposer(PreviewLoaders.emptyListFilmsLoader)
                .previewDisplayName("Empty Loader")
            
            detailNavigationComposer(PreviewLoaders.failingListFilmsLoader)
                .previewDisplayName("Failing Loader")
        }
        .preferredColorScheme(.dark)
    }
}
#endif
