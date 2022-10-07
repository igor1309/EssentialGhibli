//
//  GhibliFilmDetail.swift
//  
//
//  Created by Igor Malyarov on 07.10.2022.
//

import SwiftUI

public struct GhibliFilmDetail: View {
    public typealias FilmDetail = DetailState<GhibliDetailFilm, Error>
    
    private let detailState: FilmDetail
    
    public init(detailState: FilmDetail) {
        self.detailState = detailState
    }
    
    public var body: some View {
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
        ProgressView {
            Text("LOADING", tableName: "Detail", bundle: .module)
        }
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
}

struct GhibliFilmDetail_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                GhibliFilmDetail(detailState: .loading)
            }
            .previewDisplayName("Loading")
            
            NavigationView {
                GhibliFilmDetail(detailState: .detail(.castleInTheSky))
            }
            .previewDisplayName("Film Detail")
            
            NavigationView {
                GhibliFilmDetail(detailState: .error(APIError()))
            }
            .previewDisplayName("Error")
        }
        .preferredColorScheme(.dark)
    }
}

public struct APIError: Error {
    public init() {}
}
