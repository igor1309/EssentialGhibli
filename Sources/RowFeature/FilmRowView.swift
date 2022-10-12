//
//  FilmRowView.swift
//  
//
//  Created by Igor Malyarov on 06.10.2022.
//

import SwiftUI

public struct FilmRowView: View {
    private let item: RowFilm
    
    public init(item: RowFilm) {
        self.item = item
    }
    
    public var body: some View {
        HStack(spacing: 16) {
            Color.red
                .aspectRatio(1, contentMode: .fit)
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

struct GhibliFilmRow_Previews: PreviewProvider {
    static var previews: some View {
        List([RowFilm].samples) {
            FilmRowView(item: $0)
        }
        .listStyle(.plain)
        .preferredColorScheme(.dark)
    }
}
