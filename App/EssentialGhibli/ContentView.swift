//
//  ContentView.swift
//  EssentialGhibli
//
//  Created by Igor Malyarov on 06.10.2022.
//

import GhibliList
import GhibliRow
import SwiftUI

typealias ListItem = GhibliList.GhibliListItem
typealias RowItem = GhibliRow.GhibliListItem

struct ContentView: View {
    let items = [ListItem.castleInTheSky, .kikisDeliveryService]
    
    var body: some View {
        NavigationView {
            GhibliListView(listState: .list(items)) { item in
                NavigationLink {
                    VStack {
                        Text("TBD: \(item.title) Film Details")
                            .font(.headline)
                        
                        Spacer()
                    }
                } label: {
                    GhibliListItemRow(item: item.rowItem)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
                .environment(\.locale, .en_US)
                .previewDisplayName("en-US")
            
            ContentView()
                .environment(\.locale, .ru_RU)
                .previewDisplayName("ru-RU")
            
        }
        .preferredColorScheme(.dark)
    }
}

extension ListItem {
    var rowItem: RowItem {
        .init(id: id, title: title, description: description, image: image, film: film)
    }
}
