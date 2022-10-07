//
//  ContentView.swift
//  EssentialGhibli
//
//  Created by Igor Malyarov on 06.10.2022.
//

import Combine
import GhibliAPI
import GhibliHTTPClient
import GhibliListFeature
import GhibliRowFeature
import SwiftUI

struct ContentView: View {
    @State private var isLoading = false
    @State private var listState: ListState<GhibliListItem, Error> = .list(.samples)
    @State private var cancellable: AnyCancellable?
    
    var body: some View {
        NavigationView {
            GhibliListView(listState: listState, itemRow: itemRow)
                .toolbar(content: toolbar)
        }
    }
    
    private func itemRow(listItem: GhibliListItem) -> some View {
        NavigationLink {
            VStack {
                Text("TBD: \(listItem.title) Film Details")
                    .font(.headline)
                
                Spacer()
            }
        } label: {
            GhibliFilmRow(item: listItem.rowItem)
        }
    }
    
    private func toolbar() -> some ToolbarContent {
        ToolbarItem {
            Button(action: loadFilms, label: loadButtonLabel)
        }
    }
    
    @ViewBuilder
    private func loadButtonLabel() -> some View {
        if isLoading {
            ProgressView()
        } else {
            Label("Load items", systemImage: "square.and.arrow.down")
        }
    }
    
    private func loadFilms() {
        let httpClient = URLSessionHTTPClient(session: .shared)
        let baseURL = URL(string: "https://ghibliapi.herokuapp.com")!
        let url = FeedEndpoint.films.url(baseURL: baseURL)
        isLoading = true
        
        cancellable = httpClient
            .getPublisher(url: url)
            .handleOutput { _ in
                self.isLoading = false
            }
            .tryMap(FeedMapper.map)
            .sink { completion in
                switch completion {
                case let .failure(error):
                    self.listState = .error(error)
                    
                case .finished:
                    break
                }
            } receiveValue: { films in
                let items = films.map(\.item)
                self.listState = .list(items)
            }
    }
}

extension GhibliFilm {
    var item: GhibliListItem {
        .init(id: id, title: title, description: description, imageURL: imageURL, filmURL: filmURL)
    }
}

extension HTTPClient {
    func getPublisher(url: URL) -> AnyPublisher<(Data, HTTPURLResponse), Error> {
        Deferred {
            Future { completion in
                get(from: url, completion: completion)
            }
        }
        .eraseToAnyPublisher()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
                .environment(\.locale, .en_US)
                .previewDisplayName("en-US")
            
            ContentView()
                .environment(\.locale, .ru_RU)
                .previewDisplayName("ru-RU")
            
        }
        .preferredColorScheme(.dark)
    }
}

extension GhibliListItem {
    var rowItem: GhibliRowFilm {
        .init(id: id, title: title, description: description, imageURL: imageURL, filmURL: filmURL)
    }
}

extension Publisher {
    func handleOutput(action: @escaping (Output) -> Void) -> AnyPublisher<Output, Failure> {
        handleEvents(receiveOutput: action)
            .eraseToAnyPublisher()
    }
}
