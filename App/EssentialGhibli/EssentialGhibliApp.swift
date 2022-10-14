//
//  EssentialGhibliApp.swift
//  EssentialGhibli
//
//  Created by Igor Malyarov on 06.10.2022.
//

import API
import Combine
import SharedAPI
import SharedAPIInfra
import SwiftUI

@main
struct EssentialGhibliApp: App {
    
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
    
    var body: some Scene {
        WindowGroup {
//            LoadingImageView(loader: {
//                Just((.greenImage(width: 300, height: 600), .any200))
//                    .setFailureType(to: Error.self)
//                    .map { try! ImageMapper.map(dataResponse: $0) }
//                    .eraseToAnyPublisher()
//            })
            
             ContentView(viewModel: viewModel)
            
            // UpdatableResourceStateView_Demo()
            // LoadResourceStateView_Demo(isFailing: true)
            // LoadResourceView_Demo(isFailing: false)
        }
    }
}

private extension HTTPClient {
    func getPublisher(url: URL) -> AnyPublisher<(Data, HTTPURLResponse), Error> {
        Deferred {
            Future { completion in
                get(from: url, completion: completion)
            }
        }
        .eraseToAnyPublisher()
    }
}
