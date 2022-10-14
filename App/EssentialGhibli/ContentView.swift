//
//  ContentView.swift
//  EssentialGhibli
//
//  Created by Igor Malyarov on 06.10.2022.
//

import DetailFeature
import GenericResourceView
import ListFeature
import RowFeature
import SwiftUI

struct ContentView: View {
    @ObservedObject private var viewModel: ViewModel
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationView {
            filmListView(listState: viewModel.listState)
                .navigationTitle(Text("FEED_VIEW_TITLE", tableName: "Localizable", bundle: .main))
                .toolbar(content: toolbar)
        }
    }
    
    @ViewBuilder
    private func filmListView(listState: ListState<ListFilm, Error>) -> some View {
        switch listState {
        case .loading:
            ProgressLoadingView(loadingState: .init(isLoading: true))
        
        case let .list(films):
            FilmListView(films: films, filmRow: navLink)
            
        case let .error(stateError):
            ErrorView(errorState: .error(message: stateError.localizedDescription))
        }
    }
    
    #warning("NavigationLink destination is fixed to static value")
    private func navLink(listItem: ListFilm) -> some View {
        NavigationLink {
            ResourceStateView(resourceState: .loading) {
                FilmDetailView(film: .castleInTheSky) { _ in Color.red }
                    .navigationTitle(listItem.title)
            }
        } label: {
            itemRow(listItem: listItem)
        }
    }
    
    private func itemRow(listItem: ListFilm) -> some View {
        FilmRowView(rowFilm: listItem.rowItem) { _ in Color.red }
    }
    
    private func toolbar() -> some ToolbarContent {
        ToolbarItem {
            Button(action: viewModel.loadFilms, label: loadButtonLabel)
        }
    }
    
    @ViewBuilder
    private func loadButtonLabel() -> some View {
        if viewModel.isLoading {
            ProgressView()
        } else {
            Label("Load items", systemImage: "square.and.arrow.down")
        }
    }
}

private extension ListFilm {
    var rowItem: RowFilm {
        .init(id: id, title: title, description: description, imageURL: imageURL, filmURL: filmURL)
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        Group {
//            ContentView(viewModel: .init())
//                .environment(\.locale, .en_US)
//                .previewDisplayName("en-US")
//            
//            ContentView(viewModel: .init())
//                .environment(\.locale, .ru_RU)
//                .previewDisplayName("ru-RU")
//            
//        }
//        .preferredColorScheme(.dark)
//    }
//}
