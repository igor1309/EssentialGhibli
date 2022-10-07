//
//  GhibliFilmDetail.swift
//  
//
//  Created by Igor Malyarov on 07.10.2022.
//

import SwiftUI

public struct GhibliFilmDetail: View {
    let film: GhibliDetailFilm
    
    public init(film: GhibliDetailFilm) {
        self.film = film
    }
    
    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 6) {
                Text(verbatim: film.originalTitle)
                    .font(.headline)
                
                Text(verbatim: film.originalTitleRomanized)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                
                #warning("Image here")
                Color.red
                    .aspectRatio(1, contentMode: .fit)
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

struct GhibliFilmDetail_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            GhibliFilmDetail(film: .castleInTheSky)
        }
        .preferredColorScheme(.dark)
    }
}
