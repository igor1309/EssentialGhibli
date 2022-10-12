//
//  LoadResourceStateViewSnapshotTests.swift
//  
//
//  Created by Igor Malyarov on 09.10.2022.
//

import Combine
@testable import GenericResourceView
import SwiftUI
import XCTest

final class LoadResourceStateViewSnapshotTests: XCTestCase {
    let record = false
    
    func test_snapshotLoadResourceStateView_notFailingLoading() {
        let view = makeSUT(publisher: publisher)
        
        assert(snapshot: view, locale: .en_US, record: record)
        assert(snapshot: view, locale: .ru_RU, record: record)
    }
    
    func test_snapshotLoadResourceStateView_notFailingAfterPause() {
        let view = makeSUT(publisher: publisher)
        
        pause(for: 1)
        
        assert(snapshot: view, locale: .ru_RU, record: record)
    }
    
    func test_snapshotLoadResourceStateView_failingLoading() {
        let view = makeSUT(publisher: failingPublisher)

        assert(snapshot: view, locale: .en_US, record: record)
        assert(snapshot: view, locale: .ru_RU, record: record)
    }
    
    func test_snapshotLoadResourceStateView_failingAfterPause() {
        let view = makeSUT(publisher: failingPublisher)
        
        pause(for: 1)
        
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
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    
    private let failingPublisher: AnyPublisher<Resource, Error> = Fail(error: anyError())
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    
    private func pause(
        for interval: TimeInterval = 0.02,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        let exp = expectation(description: "Pause for \(interval)")
        DispatchQueue.main.asyncAfter(deadline: .now() + interval) {
            exp.fulfill()
        }
        wait(for: [exp], timeout: interval + 0.01)
    }
}
