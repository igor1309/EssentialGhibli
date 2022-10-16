//
//  LoadResourceStateViewSnapshotTests.swift
//  
//
//  Created by Igor Malyarov on 09.10.2022.
//

import Combine
import GenericResourceView
import SwiftUI
import XCTest

final class LoadResourceStateViewSnapshotTests: XCTestCase {
    let record = false
    
    func test_shouldShowLoadingFirst_onSuccess() {
        let view = makeSUT(publisher: publisher)
        
        assert(snapshot: view, locale: .en_US, record: record)
        assert(snapshot: view, locale: .ru_RU, record: record)
    }
    
    func test_shouldShowLoadedValue_onSuccess() {
        let view = makeSUT(publisher: publisher)
        
        pause(for: 0.5)
        
        assert(snapshot: view, locale: .ru_RU, record: record)
    }
    
    func test_shouldShowLoadingFirst_onFailingLoader() {
        let view = makeSUT(publisher: failingPublisher)

        assert(snapshot: view, locale: .en_US, record: record)
        assert(snapshot: view, locale: .ru_RU, record: record)
    }
    
    func test_shouldShowError_onFailingPublisher() {
        let view = makeSUT(publisher: failingPublisher)
        
        pause(for: 0.5)
        
        assert(snapshot: view, locale: .ru_RU, record: record)
        assert(snapshot: view, locale: .ru_RU, record: record)
    }
    
    // MARK: - Helpers
    
    typealias Resource = String
    typealias ResourceView = Text
    typealias LoadView = LoadResourceStateView<Resource, ResourceView>
    
    private func makeSUT(
        publisher: AnyPublisher<Resource, Error>,
        file: StaticString = #file,
        line: UInt = #line
    ) -> LoadView {
        let viewModel = LoadView.ViewModel(
            initialResourceState: .loading,
            publisher: publisher
        )
        let sut = LoadView(viewModel: viewModel) { Text(verbatim: $0) }
        
        trackForMemoryLeaks(viewModel, file: file, line: line)
        
        return sut
    }
    
    private let publisher: AnyPublisher<Resource, Error> = Just("This is a real value.")
        .setFailureType(to: Error.self)
        .delay(for: 0.01, scheduler: DispatchQueue.main)
        .eraseToAnyPublisher()
    
    private let failingPublisher: AnyPublisher<Resource, Error> = Fail(error: anyError())
        .delay(for: 0.01, scheduler: DispatchQueue.main)
        .eraseToAnyPublisher()
}
