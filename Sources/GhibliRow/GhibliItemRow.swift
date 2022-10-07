//
//  GhibliItemRow.swift
//  
//
//  Created by Igor Malyarov on 06.10.2022.
//

import SwiftUI

public struct GhibliItemRow: View {
    private let item: GhibliRowItem
    
    public init(item: GhibliRowItem) {
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
    static let items = [GhibliRowItem.castleInTheSky, .kikisDeliveryService]
    
    static var previews: some View {
        List(items) {
            GhibliItemRow(item: $0)
        }
        .listStyle(.plain)
        .preferredColorScheme(.dark)
    }
}
