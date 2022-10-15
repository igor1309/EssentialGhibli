//
//  Publisher+fallback.swift
//
//
//  Created by Igor Malyarov on 15.10.2022.
//

import Combine

extension Publisher {
    func fallback(
        to fallbackPublisher: @escaping () -> AnyPublisher<Output, Failure>
    ) -> AnyPublisher<Output, Failure> {
        self.catch { _ in fallbackPublisher() }
            .eraseToAnyPublisher()
    }
}
