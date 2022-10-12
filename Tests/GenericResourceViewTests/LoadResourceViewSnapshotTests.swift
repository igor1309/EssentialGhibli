//
//  LoadResourceViewSnapshotTests.swift
//  
//
//  Created by Igor Malyarov on 09.10.2022.
//

import Combine
@testable import GenericResourceView
import Presentation
import SwiftUI
import XCTest

final class LoadResourceViewSnapshotTests: XCTestCase {
    let record = false
    
    func test_snapshotLoadResourceStateView_notFailing() {
        let view = makeSUT(loader: loader)
        
        assert(snapshot: view, locale: .en_US, record: record)
        assert(snapshot: view, locale: .ru_RU, record: record)
    }
    
    func test_snapshotLoadResourceStateView_notFailingAfterPause() {
        let view = makeSUT(loader: loader)

        pause(for: 0.05)

        assert(snapshot: view, locale: .en_US, record: record)
    }

    func test_snapshotLoadResourceStateView_failing() {
        let view = makeSUT(loader: failingLoader)
        
        assert(snapshot: view, locale: .en_US, record: record)
        assert(snapshot: view, locale: .ru_RU, record: record)
    }
    
    func test_snapshotLoadResourceStateView_failingAfterPause() {
        let view = makeSUT(loader: failingLoader)

        pause(for: 0.05)

        assert(snapshot: view, locale: .en_US, record: record)
    }
    
    // MARK: - Helpers
    
    typealias Resource = String
    typealias ResourceViewModel = String
    typealias ViewModel = LoadResourceViewModel<Resource, ResourceViewModel>
    
    private func makeSUT(
        loader: @escaping () -> AnyPublisher<Resource, Error>,
        file: StaticString = #file,
        line: UInt = #line
    ) -> some View {
        let viewModel = ViewModel(
            loader: loader,
            mapper: { $0 }
        )
        
        func resourceView(resource: Resource?) -> some View {
            resource.map { resource in
                Text.init(verbatim: resource)
            }
        }
        
        @ViewBuilder
        func loadingView(state: LoadingState) -> some View {
            if state.isLoading {
                ProgressView {
                    Text("LOADING", tableName: "Localizable", bundle: .module)
                }
            } else {
                EmptyView()
            }
        }
        
        @ViewBuilder
        func errorView(state: ErrorState) -> some View {
            switch state {
            case .noError:
                EmptyView()
                
            case let .error(message):
                Text(message)
                    .foregroundColor(.white)
                    .padding()
                    .background(.red)
                    .padding()
            }
        }
        
        let sut = LoadResourceView(
            viewModel: viewModel,
            resourceView: resourceView,
            loadingView: loadingView,
            errorView: errorView
        )
        
        trackForMemoryLeaks(viewModel, file: file, line: line)
        
        return sut
    }
    
    let loader: () -> AnyPublisher<Resource, Error> = {
        Just("This is a final state.")
            .delay(for: 0.02, scheduler: DispatchQueue.main)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    let failingLoader: () -> AnyPublisher<Resource, Error> = {
        Fail(error: anyError())
            .delay(for: 0.02, scheduler: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
