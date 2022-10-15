//
//  LoaderComposer+ext.swift
//  EssentialGhibli
//
//  Created by Igor Malyarov on 15.10.2022.
//

import ListFeature

#if DEBUG
extension LoaderComposer {
    private convenience init(httpStub: HTTPClientStub) {
        self.init(httpClient: httpStub, store: NullStore<ListFilm>())
    }
    
    static let online: LoaderComposer = .init(httpStub: .online)
    static let offline: LoaderComposer = .init(httpStub: .offline)
}
#endif
