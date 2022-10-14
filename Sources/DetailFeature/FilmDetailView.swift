//
//  FilmDetailView.swift
//  
//
//  Created by Igor Malyarov on 07.10.2022.
//

import SwiftUI

public struct FilmDetailView<Poster>: View
where Poster: View {
    
    private let film: DetailFilm
    private let poster: (DetailFilm) -> Poster
    
    public init(
        film: DetailFilm,
        poster: @escaping (DetailFilm) -> Poster
    ) {
        self.film = film
        self.poster = poster
    }
    
    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 6) {
                Text(verbatim: film.originalTitle)
                    .font(.headline)
                
                Text(verbatim: film.originalTitleRomanized)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                
                poster(film)
                    .cornerRadius(24)
                    .padding(.vertical, 6)
                
                VStack {
                    executive("director", film.director)
                    executive("producer", film.producer)
                }
                
                Text(verbatim: film.description)
                    .font(.body)
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        }
        .navigationTitle(film.title)
    }
    
    private func executive(_ title: String, _ name: String) -> some View {
        HStack(alignment: .firstTextBaseline) {
            Text(title.uppercased())
                .foregroundStyle(.secondary)
                .font(.caption)
            
            Spacer()
            
            Text(verbatim: name)
        }
    }
}

struct FilmDetailView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                FilmDetailView(film: .castleInTheSky) { _ in
                    Color.red.aspectRatio(1, contentMode: .fit)
                }
            }
            
            NavigationView {
                FilmDetailView(film: .castleInTheSky) { _ in
                    Color.cyan
                        .aspectRatio(1, contentMode: .fit)
                        .overlay {
                            Image(systemName: "exclamationmark.triangle")
                                .resizable()
                                .scaledToFit()
                        }
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}
