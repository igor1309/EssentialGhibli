//
//  ContentViewComposer.swift
//  EssentialGhibli
//
//  Created by Igor Malyarov on 15.10.2022.
//

import API
import SharedAPIInfra
import SwiftUI

struct ContentViewComposer: View {
    @StateObject private var viewModel = ViewModel(
        listState: .list(.samples),
        httpPublisher: {
            let session: URLSession = .shared
            let httpClient = URLSessionHTTPClient(session: session)
            let baseURL = URL(string: "https://ghibliapi.herokuapp.com")!
            let url = FeedEndpoint.films.url(baseURL: baseURL)
            let httpPublisher = httpClient
                .getPublisher(url: url)
                .delay(for: 2, scheduler: DispatchQueue.main)
                .eraseToAnyPublisher()
            return httpPublisher
        }()
    )
    
    var body: some View {
        ContentView(viewModel: viewModel)
    }
}

struct ContentViewComposer_Previews: PreviewProvider {
    static var previews: some View {
        ContentViewComposer()
    }
}
