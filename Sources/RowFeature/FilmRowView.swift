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

#if DEBUG
struct FilmRowView_Previews: PreviewProvider {
    static var previews: some View {
        List([RowFilm].samples) {
            FilmRowView(rowFilm: $0) { _ in
                Color.red
                    .aspectRatio(1, contentMode: .fit)
                    .frame(height: 90)
            }

            FilmRowView(rowFilm: $0) { _ in
                Color.red
                    .aspectRatio(2/3, contentMode: .fit)
            }

            FilmRowView(rowFilm: $0) { _ in
                Color.indigo
                    .aspectRatio(2/3, contentMode: .fill)
                    .frame(width: 60, height: 90)
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
#endif
