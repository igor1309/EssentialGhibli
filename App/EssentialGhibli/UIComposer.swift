//
//  UIComposer.swift
//  EssentialGhibli
//
//  Created by Igor Malyarov on 14.10.2022.
//

import ListFeature
import SwiftUI

struct UIComposer: View {
    
    let loader: Loader
    
    var body: some View {
        DetailNavigationComposer(
            filmsLoader: LoaderFactory.filmsLoader(loader: loader),
            filmRow: filmRow,
            filmDetail: filmDetail
        )
    }
    
    private func filmRow(listFilm: ListFilm) -> some View {
        FilmRowViewAdapter(
            listFilm: listFilm,
            imageLoader: LoaderFactory.filmRowImageLoader(loader: loader)
        )
    }
    
    private func filmDetail(listFilm: ListFilm) -> some View {
        FilmDetailViewAdapter(
            listFilm: listFilm,
            loader: { LoaderFactory.detailLoader(loader: loader)(listFilm) },
            imageLoader: LoaderFactory.filmDetailImageLoader(loader: loader)
        )
    }
}

//struct UIComposer_Previews: PreviewProvider {
//    static var previews: some View {
//        UIComposer {
//            
//        }
//    }
//}
