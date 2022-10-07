//
//  ViewModel.swift
//  EssentialGhibli
//
//  Created by Igor Malyarov on 07.10.2022.
//

import Combine
import GhibliAPI
import GhibliHTTPClient
import GhibliListFeature
import GhibliRowFeature
import SwiftUI

final class ViewModel: ObservableObject {
    @Published private(set) var listState: ListState<GhibliListFilm, Error> = .list(.samples)
    @Published private(set) var cancellable: AnyCancellable?
    
    var isLoading: Bool {
        get {
            if case .loading = listState {
                return true
            } else {
                return false
            }
        }
        set {
            if newValue {
                listState = .loading
            }
        }
    }
    
    func loadFilms() {
        let httpClient = URLSessionHTTPClient(session: .shared)
        let baseURL = URL(string: "https://ghibliapi.herokuapp.com")!
        let url = FeedEndpoint.films.url(baseURL: baseURL)
        isLoading = true
        
        cancellable = httpClient
            .getPublisher(url: url)
            .delay(for: 2, scheduler: DispatchQueue.main)
            .handleOutput { [weak self] _ in
                self?.isLoading = false
            }
            .tryMap(FeedMapper.map)
            .sink { [weak self] completion in
                switch completion {
                case let .failure(error):
                    self?.listState = .error(error)
                    
                case .finished:
                    break
                }
            } receiveValue: { [weak self] films in
                let items = films.map(\.item)
                self?.listState = .list(items)
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

private extension Publisher {
    func handleOutput(action: @escaping (Output) -> Void) -> AnyPublisher<Output, Failure> {
        handleEvents(receiveOutput: action)
            .eraseToAnyPublisher()
    }
}

private extension GhibliFilm {
    var item: GhibliListFilm {
        .init(id: id, title: title, description: description, imageURL: imageURL, filmURL: filmURL)
    }
}
