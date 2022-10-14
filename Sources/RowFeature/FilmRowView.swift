//
//  FilmRowView.swift
//  
//
//  Created by Igor Malyarov on 06.10.2022.
//

import SwiftUI

public struct FilmRowView<Thumbnail>: View
where Thumbnail: View {
    
    private let rowFilm: RowFilm
    private let thumbnail: (RowFilm) -> Thumbnail
    
    public init(
        rowFilm: RowFilm,
        thumbnail: @escaping (RowFilm) -> Thumbnail
    ) {
        self.rowFilm = rowFilm
        self.thumbnail = thumbnail
    }
    
    public var body: some View {
        HStack(spacing: 16) {
            thumbnail(rowFilm)
                .cornerRadius(12)
                .frame(width: 88, height: 88)
            
            VStack(alignment: .leading, spacing: 16) {
                Text(rowFilm.title)
                    .font(.headline)
                
                Text(rowFilm.description)
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
            FilmRowView(rowFilm: $0) { _ in
                Color.red
                    .aspectRatio(1, contentMode: .fit)
            }
            
            FilmRowView(rowFilm: $0) { _ in
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
