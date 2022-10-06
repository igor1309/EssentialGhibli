//
//  GhibliListView.swift
//  
//
//  Created by Igor Malyarov on 06.10.2022.
//

import SwiftUI

public struct GhibliListView: View {
    private let listState: ListState<GhibliListItem, Error>
    
    public init(listState: ListState<GhibliListItem, Error>) {
        self.listState = listState
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
        ProgressView("Loading...")
    }
    
    private func emptyListView() -> some View {
        Text("List is empty.")
            .foregroundColor(.secondary)
    }
    
    private func errorView(_ stateError: Error) -> some View {
        Text(stateError.localizedDescription)
            .foregroundColor(.white)
            .background(.red)
    }
    
    private func list(items: [GhibliListItem]) -> some View {
        List {
            ForEach(items, content: GhibliListItemRow.init)
        }
        .listStyle(.plain)
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            GhibliListView(listState: .loading)
            GhibliListView(listState: .empty)
            GhibliListView(listState: .list([.castleInTheSky, .kikisDeliveryService]))
            GhibliListView(listState: .error(APIError()))
        }
            .preferredColorScheme(.dark)
    }
}

public struct APIError: Error {
    public init() {}
}
