//
//  FilmListView.swift
//  
//
//  Created by Igor Malyarov on 06.10.2022.
//

import SwiftUI

public struct FilmListView<Row: View>: View {
    private let listState: ListState<ListFilm, Error>
    
    private let itemRow: (ListFilm) -> Row
    
    public init(
        listState: ListState<ListFilm, Error>,
        itemRow: @escaping (ListFilm) -> Row
    ) {
        self.listState = listState
        self.itemRow = itemRow
    }
    
    public var body: some View {
        switch listState {
        case .loading:
            loadingView()
        case .empty:
            emptyListView()
        case let .list(items):
            list(items: items)
        case let .error(stateError):
            errorView(stateError)
        }
    }
    
    private func loadingView() -> some View {
        ProgressView {
            Text("LOADING", tableName: "Feed", bundle: .module)
        }
    }
    
    private func emptyListView() -> some View {
        Text("EMPTY_LIST_MESSAGE", tableName: "Feed", bundle: .module)
            .foregroundColor(.secondary)
    }
    
    private func errorView(_ error: Error) -> some View {
        Text(error.localizedDescription)
            .foregroundColor(.white)
            .padding()
            .background(.red)
            .cornerRadius(24)
            .padding()
    }
    
    private func list(items: [ListFilm]) -> some View {
        List {
            ForEach(items, content: itemRow)
        }
        .listStyle(.plain)
    }
}

struct GhibliListView_Previews: PreviewProvider {
    
    static func ghibliListView(
        _ listState: ListState<ListFilm, Error>
    ) -> some View {
        FilmListView(listState: listState) { item in
            NavigationLink {
                Text("TBD: item detail")
            } label: {
                Text(item.title)
            }
            
        }
    }
    
    static var previews: some View {
        Group {
            ghibliListView(.loading)
                .previewDisplayName("Loading List State")
            
            ghibliListView(.empty)
                .previewDisplayName("Empty List State")
            
            NavigationView {
                ghibliListView(.list(.samples))
            }
            .previewDisplayName("en-US | List State")
            .environment(\.locale, .en_US)
            
            NavigationView {
                ghibliListView(.list(.samples))
            }
            .previewDisplayName("ru-RU | List State")
            
            ghibliListView(.error(APIError()))
                .previewDisplayName("Error List State")
        }
        .environment(\.locale, .ru_RU)
        .preferredColorScheme(.dark)
    }
}

public extension Locale {
    static let en_US: Self = .init(identifier: "en-US")
    static let ru_RU: Self = .init(identifier: "ru-RU")
}
