//
//  NavigationComposer.swift
//  EssentialGhibli
//
//  Created by Igor Malyarov on 07.10.2022.
//

import SwiftUI

//struct NavigationComposer<List, ListRow, Row, Detail>: View
//where List: View,
//      ListRow: View,
//      Row: View,
//      Detail: View {
//
//    @ObservedObject private var viewModel: ViewModel
//
//    private let list: (ListState<GhibliListFilm, Error>, @escaping (GhibliListFilm) -> ListRow) -> List
//    private let row: () -> Row
//    private let transform: (Row) -> ListRow
//    private let detail: () -> Detail
//
//    var body: some View {
//        NavigationView {
//            list(viewModel.listState, itemRow)
//        }
//    }
//    private func itemRow(listItem: GhibliListFilm) -> ListRow {
//        NavigationLink {
//            GhibliFilmDetail(
//                filmTitle: "Castle in the Sky",
//                detailState: .detail(.castleInTheSky)
//            )
//            .navigationTitle(listItem.title)
//        } label: {
//            GhibliFilmRowView(item: listItem.rowItem)
//        }
//    }
//}


//struct NavigationComposer_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationComposer()
//    }
//}
