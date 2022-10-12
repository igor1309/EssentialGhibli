//
//  LoadResourceStateView.swift
//  EssentialGhibli
//
//  Created by Igor Malyarov on 08.10.2022.
//

import Combine
import Presentation
import SwiftUI

public struct LoadResourceStateView<Resource, ResourceView>: View
where ResourceView: View {
    
    @ObservedObject private var viewModel: ViewModel
    
    private let resourceView: (Resource) -> ResourceView
    
    public init(
        viewModel: ViewModel,
        resourceView: @escaping (Resource) -> ResourceView
    ) {
        self.viewModel = viewModel
        self.resourceView = resourceView
    }
    
    public var body: some View {
        ResourceStateView(
            resourceState: viewModel.resourceState,
            resourceView: resourceView
        )
        .onTapGesture(perform: viewModel.loadResource)
    }
}

extension LoadResourceStateView {
    public final class ViewModel: ObservableObject {
        @Published private(set) var resourceState: ResourceState<Resource, Error>
        
        private let publisher: AnyPublisher<Resource, Error>
        private var cancellable: AnyCancellable?
        
        public init(
            initialResourceState: ResourceState<Resource, Error>,
            publisher: AnyPublisher<Resource, Error>
        ) {
            self.resourceState = initialResourceState
            self.publisher = publisher
            
            loadResource()
        }
        
        func loadResource() {
            resourceState = .loading
            
            cancellable = publisher
                .dispatchOnMainQueue()
                .sink { [weak self] completion in
                    switch completion {
                    case let .failure(error):
                        self?.resourceState = .error(error)
                        
                    case .finished:
                        break
                    }
                } receiveValue: { [weak self] resource in
                    self?.resourceState = .resource(resource)
                }
        }
    }
}

#if DEBUG
struct LoadResourceStateView_Demo: View {
    let isFailing: Bool
    
    private let publisher: AnyPublisher<String, Error> = Just("This is a real value.")
        .setFailureType(to: Error.self)
        .delay(for: 2, scheduler: DispatchQueue.main)
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    
    private let failingPublisher: AnyPublisher<String, Error> = Fail(error: AnyError())
        .delay(for: 2, scheduler: DispatchQueue.main)
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    
    var body: some View {
        LoadResourceStateView(
            viewModel: .init(
                initialResourceState: .loading,
                publisher: isFailing ? failingPublisher : publisher
            ),
            resourceView: Text.init(verbatim:))
    }
}

struct LoadResourceStateView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LoadResourceStateView_Demo(isFailing: false)
            
            LoadResourceStateView_Demo(isFailing: true)
                .previewDisplayName("With Failing Publisher")
        }
        .preferredColorScheme(.dark)
    }
}

private struct AnyError: Error {}
#endif
