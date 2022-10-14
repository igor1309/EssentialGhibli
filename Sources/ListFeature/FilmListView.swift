//
//  FilmListView.swift
//  
//
//  Created by Igor Malyarov on 06.10.2022.
//

import SwiftUI

public struct FilmListView<Row: View>: View {
    private let films: [ListFilm]
    
    private let filmRow: (ListFilm) -> Row
    
    public init(
        films: [ListFilm],
        filmRow: @escaping (ListFilm) -> Row
    ) {
        self.films = films
        self.filmRow = filmRow
    }
    
    public var body: some View {
        if films.isEmpty {
            emptyListView()
        } else {
            list(films: films)
        }
    }
    
    private func emptyListView() -> some View {
        Text("EMPTY_LIST_MESSAGE", tableName: "Feed", bundle: .module)
            .foregroundColor(.secondary)
    }
    
    private func list(films: [ListFilm]) -> some View {
        List {
            ForEach(films, content: filmRow)
        }
        .listStyle(.plain)
    }
}

struct FilmListView_Previews: PreviewProvider {
    
    static func filmListView(
        _ films: [ListFilm]
    ) -> some View {
        FilmListView(films: films) { films in
            NavigationLink {
                Text("Item detail here")
            } label: {
                Text(films.title)
            }
            
        }
    }
    
    static var previews: some View {
        Group {
            filmListView([])
                .previewDisplayName("ru-RU | Empty List")
                .environment(\.locale, .ru_RU)

            filmListView([])
                .previewDisplayName("en-US | Empty List")
                .environment(\.locale, .en_US)

            NavigationView {
                filmListView(.samples)
            }
            .previewDisplayName("en-US | List")
            .environment(\.locale, .en_US)
            
            NavigationView {
                filmListView(.samples)
            }
            .previewDisplayName("ru-RU | List")
            .environment(\.locale, .ru_RU)
        }
        .preferredColorScheme(.dark)
    }
}

private extension Locale {
    static let en_US: Self = .init(identifier: "en-US")
    static let ru_RU: Self = .init(identifier: "ru-RU")
}
