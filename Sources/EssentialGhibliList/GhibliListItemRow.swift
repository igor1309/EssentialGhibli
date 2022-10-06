//
//  GhibliListItemRow.swift
//  
//
//  Created by Igor Malyarov on 06.10.2022.
//

import SwiftUI

struct GhibliListItemRow: View {
    let item: GhibliListItem
    
    var body: some View {
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
    static var previews: some View {
        GhibliListItemRow(item: .castleInTheSky)
            .preferredColorScheme(.dark)
    }
}
