//
//  UIComposer.swift
//  EssentialGhibli
//
//  Created by Igor Malyarov on 14.10.2022.
//

import ListFeature
import RowFeature
import DetailFeature
import SwiftUI

struct UIComposer: View {
    
    let loader: LoaderComposer
    
    var body: some View {
        NavigationView {
            DetailNavigationComposer(
                filmsLoader: loader.filmsLoader,
                filmRow: filmRow,
                filmDetail: filmDetail
            )
            .navigationTitle(Text("FEED_VIEW_TITLE", tableName: "Localizable", bundle: .main))
        }
    }
    
    private func filmRow(listFilm: ListFilm) -> some View {
        FilmRowViewAdapter(
            listFilm: listFilm,
            imageLoader: loader.filmRowImageLoader
        )
    }
    
    private func filmDetail(listFilm: ListFilm) -> some View {
        let detailLoader = { loader.detailLoader(listFilm: listFilm) }
        
        return FilmDetailViewAdapter(
            loader: detailLoader,
            imageLoader: loader.filmDetailImageLoader
        )
    }
}

extension LoaderComposer {
    func filmRowImageLoader(rowFilm: RowFilm) -> ImagePublisher {
        filmImageLoader(url: rowFilm.imageURL)
    }
    
    func filmDetailImageLoader(detailFilm: DetailFilm) -> ImagePublisher {
        filmImageLoader(url: detailFilm.imageURL)
    }
}

struct UIComposer_Previews: PreviewProvider {
    static let online = LoaderComposer(
        httpClient: HTTPClientStub.online,
        store: NullStore<ListFilm>()
    )
    
    static let offline = LoaderComposer(
        httpClient: HTTPClientStub.offline,
        store: NullStore<ListFilm>()
    )
    
    static var previews: some View {
        Group {
            UIComposer(loader: online)
                .environment(\.locale, .ru_RU)
                .previewDisplayName("ru | Online")
            
            UIComposer(loader: online)
                .previewDisplayName("Online")
            
            UIComposer(loader: offline)
                .environment(\.locale, .ru_RU)
                .previewDisplayName("ru | Offline")

            UIComposer(loader: offline)
                .previewDisplayName("Offline")
        }
        .preferredColorScheme(.dark)
    }
}
