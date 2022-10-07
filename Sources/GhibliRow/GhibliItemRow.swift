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
        HStack(spacing: 16) {
            Color.red
                .aspectRatio(contentMode: .fit)
                .cornerRadius(12)
                .frame(height: 88)
            
            VStack(alignment: .leading, spacing: 16) {
                Text(item.title)
                    .font(.headline)
                
                Text(item.description)
                    .foregroundStyle(.secondary)
                    .font(.subheadline)
                    .lineLimit(3)
            }
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
