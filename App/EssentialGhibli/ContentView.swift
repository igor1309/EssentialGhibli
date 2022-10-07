//
//  ContentView.swift
//  EssentialGhibli
//
//  Created by Igor Malyarov on 06.10.2022.
//

import Combine
import GhibliAPI
import GhibliHTTPClient
import GhibliListFeature
import GhibliRowFeature
import SwiftUI

struct ContentView: View {
    @ObservedObject private var viewModel: ViewModel
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationView {
            GhibliFilmListView(listState: viewModel.listState, itemRow: itemRow)
                .toolbar(content: toolbar)
        }
    }
    
    private func itemRow(listItem: GhibliListFilm) -> some View {
        NavigationLink {
            VStack {
                Text("TBD: \(listItem.title) Film Details")
                    .font(.headline)
                
                Spacer()
            }
        } label: {
            GhibliFilmRow(item: listItem.rowItem)
        }
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

private extension GhibliListFilm {
    var rowItem: GhibliRowFilm {
        .init(id: id, title: title, description: description, imageURL: imageURL, filmURL: filmURL)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView(viewModel: .init())
                .environment(\.locale, .en_US)
                .previewDisplayName("en-US")
            
            ContentView(viewModel: .init())
                .environment(\.locale, .ru_RU)
                .previewDisplayName("ru-RU")
            
        }
        .preferredColorScheme(.dark)
    }
}
