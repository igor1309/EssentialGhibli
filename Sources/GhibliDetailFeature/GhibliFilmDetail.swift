//
//  GhibliFilmDetail.swift
//  
//
//  Created by Igor Malyarov on 07.10.2022.
//

import SwiftUI

public struct GhibliFilmDetail: View {
    public typealias FilmDetail = DetailState<GhibliDetailFilm, Error>
    
    private let filmTitle: String
    private let detailState: FilmDetail
    
    public init(
        filmTitle: String,
        detailState: FilmDetail
    ) {
        self.filmTitle = filmTitle
        self.detailState = detailState
    }
    
    public var body: some View {
        stateView(detailState)
            .navigationTitle(filmTitle)
    }
    
    @ViewBuilder
    private func stateView(_ detailState: FilmDetail) -> some View {
        switch detailState {
        case .loading:
            loadingView()
            
        case let .detail(film):
            detail(film: film)
            
        case let .error(error):
            errorView(error)
        }
    }
    
    private func loadingView() -> some View {
        ProgressView("LOADING")
    }
    
    private func detail(film: GhibliDetailFilm) -> some View {
        DetailView(film: film)
    }
    
    private func errorView(_ error: Error) -> some View {
        Text(error.localizedDescription)
            .foregroundColor(.white)
            .padding()
            .background(.red)
            .cornerRadius(24)
            .padding()
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
        Group {
            NavigationView {
                GhibliFilmDetail(
                    filmTitle: "Castle in the Sky",
                    detailState: .loading
                )
            }
            .previewDisplayName("Loading")
            
            NavigationView {
                GhibliFilmDetail(
                    filmTitle: "Castle in the Sky",
                    detailState: .detail(.castleInTheSky)
                )
            }
            .previewDisplayName("Film Detail")
            
            NavigationView {
                GhibliFilmDetail(
                    filmTitle: "Castle in the Sky",
                    detailState: .error(APIError())
                )
            }
            .previewDisplayName("Error")
        }
        .preferredColorScheme(.dark)
    }
}

#if DEBUG
private struct APIError: Error {}
#endif
