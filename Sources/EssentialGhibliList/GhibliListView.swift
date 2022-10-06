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
        ProgressView("Loading...")
    }
    
    private func emptyListView() -> some View {
        Text("List is empty.")
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
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static func ghibliListView(
        _ listState: ListState<GhibliListItem, Error>
    ) -> some View {
        GhibliListView(listState: listState) {
            Text($0.title)
        }
    }
    
    static var previews: some View {
        Group {
            ghibliListView(.loading)
            ghibliListView(.empty)
            ghibliListView(.list([.castleInTheSky, .kikisDeliveryService]))
            ghibliListView(.error(APIError()))
        }
        .preferredColorScheme(.dark)
    }
}

public struct APIError: Error {
    public init() {}
}
