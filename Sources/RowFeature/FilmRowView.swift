//
//  FilmRowView.swift
//  
//
//  Created by Igor Malyarov on 06.10.2022.
//

import SwiftUI

public struct FilmRowView<Thumbnail>: View
where Thumbnail: View {
    
    private let item: RowFilm
    private let thumbnail: (RowFilm) -> Thumbnail
    
    public init(
        item: RowFilm,
        thumbnail: @escaping (RowFilm) -> Thumbnail
    ) {
        self.item = item
        self.thumbnail = thumbnail
    }
    
    public var body: some View {
        HStack(spacing: 16) {
            thumbnail(item)
                .cornerRadius(12)
                .frame(width: 88, height: 88)
            
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
            FilmRowView(item: $0) { _ in
                Color.red
                    .aspectRatio(1, contentMode: .fit)
            }
            
            FilmRowView(item: $0) { _ in
                Color.cyan
                    .overlay {
                        Image(systemName: "exclamationmark.triangle")
                            .resizable()
                            .scaledToFit()
                    }
            }
        }
        .listStyle(.plain)
        .preferredColorScheme(.dark)
    }
}
