//
//  GhibliListView.swift
//  
//
//  Created by Igor Malyarov on 06.10.2022.
//

import SwiftUI

public struct GhibliListView: View {
    private let items: [GhibliListItem]
    
    public init(
        items: [GhibliListItem]
    ) {
        self.items = items
    }
    
    public var body: some View {
        List {
            ForEach(items, content: GhibliListItemRow.init)
        }
        .listStyle(.plain)
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        GhibliListView(items: [.castleInTheSky, .kikisDeliveryService])
            .preferredColorScheme(.dark)
    }
}
