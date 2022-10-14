//
//  ViewModel.swift
//  EssentialGhibli
//
//  Created by Igor Malyarov on 07.10.2022.
//

import API
import Combine
import Domain
import Foundation
import ListFeature

final class ViewModel: ObservableObject {
    @Published private(set) var listState: ListState<ListFilm, Error>
    @Published private(set) var cancellable: AnyCancellable?
    
    typealias HTTPPublisher = AnyPublisher<(Data, HTTPURLResponse), Error>
    
    private let httpPublisher: HTTPPublisher
    
    init(
        listState: ListState<ListFilm, Error>,
        httpPublisher: HTTPPublisher
    ) {
        self.listState = listState
        self.httpPublisher = httpPublisher
    }
    
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
        isLoading = true
        
        cancellable = httpPublisher
            .tryMap(FeedMapper.map)
            .sink { [weak self] completion in
                switch completion {
                case let .failure(error):
                    self?.listState = .error(error)
                    
                case .finished:
                    break
                }
                self?.isLoading = false
            } receiveValue: { [weak self] films in
                let items = films.map(\.item)
                self?.listState = .list(items)
                self?.isLoading = false
            }
    }
}

private extension GhibliFilm {
    var item: ListFilm {
        .init(id: id, title: title, description: description, imageURL: imageURL, filmURL: filmURL)
    }
}
