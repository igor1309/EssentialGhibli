//
//  GhibliListItemRow.swift
//  
//
//  Created by Igor Malyarov on 06.10.2022.
//

import SwiftUI

public struct GhibliListItemRow: View {
    private let item: GhibliListItem
    
    public init(item: GhibliListItem) {
        self.item = item
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(item.title)
                .font(.headline)
            
            Text(item.description)
                .foregroundStyle(.secondary)
                .font(.subheadline)
        }
    }
}

struct GhibliListItemRow_Previews: PreviewProvider {
    static let items = [GhibliListItem.castleInTheSky, .kikisDeliveryService]
    
    static var previews: some View {
        List(items) {
            GhibliListItemRow(item: $0)
        }
        .listStyle(.plain)
        .preferredColorScheme(.dark)
    }
}
