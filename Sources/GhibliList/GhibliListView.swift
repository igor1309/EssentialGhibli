//
//  GhibliListView.swift
//  
//
//  Created by Igor Malyarov on 06.10.2022.
//

import SwiftUI

public struct GhibliListView<Row: View>: View {
    private let listState: ListState<GhibliListItem, Error>
    
    private let itemRow: (GhibliListItem) -> Row
    
    public init(
        listState: ListState<GhibliListItem, Error>,
        itemRow: @escaping (GhibliListItem) -> Row
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
    
    private func errorView(_ stateError: Error) -> some View {
        Text(stateError.localizedDescription)
            .foregroundColor(.white)
            .padding()
            .background(.red)
            .cornerRadius(24)
    }
    
    private func list(items: [GhibliListItem]) -> some View {
        List {
            ForEach(items, content: itemRow)
        }
        .listStyle(.plain)
        .navigationTitle(Text("FEED_VIEW_TITLE", tableName: "Feed", bundle: .module))
    }
}

struct GhibliListView_Previews: PreviewProvider {
    
    static func ghibliListView(
        _ listState: ListState<GhibliListItem, Error>
    ) -> some View {
        GhibliListView(listState: listState) { item in
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
                ghibliListView(.list([.castleInTheSky, .kikisDeliveryService]))
            }
            .previewDisplayName("en-US | List State")
            .environment(\.locale, .en_US)
            
            NavigationView {
                ghibliListView(.list([.castleInTheSky, .kikisDeliveryService]))
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
