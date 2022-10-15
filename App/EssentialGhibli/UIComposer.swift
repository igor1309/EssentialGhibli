//
//  UIComposer.swift
//  EssentialGhibli
//
//  Created by Igor Malyarov on 14.10.2022.
//

import Cache
import ListFeature
import RowFeature
import DetailFeature
import SwiftUI

struct UIComposer {
    
    let loader: LoaderComposer
    
    var body: some View {
        DetailNavigationComposer(
            filmsLoader: loader.filmsLoader,
            filmRow: filmRow,
            filmDetail: filmDetail
        )
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

//struct UIComposer_Previews: PreviewProvider {
//    static var previews: some View {
//        UIComposer {
//            
//        }
//    }
//}
