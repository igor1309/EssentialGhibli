//
//  LoaderComposer+ext.swift
//  EssentialGhibli
//
//  Created by Igor Malyarov on 15.10.2022.
//

import Combine
import Foundation
import ListFeature

#if DEBUG
extension LoaderComposer {
    static let online: LoaderComposer = .init(httpStub: .online(response200))
    static let offline: LoaderComposer = .init(httpStub: .offline)
    static let empty: LoaderComposer = .init(httpStub: .offline)

    func longFilmsLoader() -> AnyPublisher<[ListFilm], Error> {
        filmsLoader()
            .delay(for: 10, scheduler: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    private convenience init(httpStub: HTTPClientStub) {
        self.init(httpClient: httpStub, store: NullStore<ListFilm>())
    }
}
#endif
