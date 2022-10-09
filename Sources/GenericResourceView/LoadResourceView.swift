//
//  LoadResourceView.swift
//  EssentialGhibli
//
//  Created by Igor Malyarov on 08.10.2022.
//

import Combine
import Presentation
import SwiftUI

final class LoadResourceViewModel<Resource, ResourceViewModel>: ObservableObject {
    
    @Published private(set) var errorState: ErrorState
    @Published private(set) var loadingState: LoadingState
    @Published private(set) var resourceViewModel: ResourceViewModel?
    
    private let loader: () -> AnyPublisher<Resource, Error>
    private let mapper: (Resource) throws -> ResourceViewModel
    private var cancellable: Cancellable?

    init(
        errorState: ErrorState,
        loadingState: LoadingState,
        resourceViewModel: ResourceViewModel? = nil,
        loader: @escaping () -> AnyPublisher<Resource, Error>,
        mapper: @escaping (Resource) -> ResourceViewModel
    ) {
        self.errorState = errorState
        self.loadingState = loadingState
        self.resourceViewModel = resourceViewModel
        self.loader = loader
        self.mapper = mapper
        
        loadResource()
    }
    
    func loadResource() {
        didStartLoading()
        
        cancellable = loader()
            .dispatchOnMainQueue()
            .sink { [weak self] completion in
                switch completion {
                case .finished: break
                    
                case let .failure(error):
                    self?.didFinishLoading(with: error)
                }
            } receiveValue: { [weak self] resource in
                self?.didFinishLoading(with: resource)
            }
    }
    
    private func didStartLoading() {
        errorState = .noError
        loadingState = .init(isLoading: true)
    }
    
    private func didFinishLoading(with resource: Resource) {
        do {
            resourceViewModel = try mapper(resource)
            loadingState = .init(isLoading: false)
        } catch {
            didFinishLoading(with: error)
        }
    }
    
    private func didFinishLoading(with error: Error) {
        // or map to another error
        errorState = .error(message: error.localizedDescription)
        loadingState = .init(isLoading: false)
    }
}

struct LoadResourceView<
    Resource,
    ResourceViewModel,
    ResourceView,
    ResourceLoadingView,
    ResourceErrorView>: View
where ResourceView: View,
      ResourceLoadingView: View,
      ResourceErrorView: View {
    
    typealias ViewModel = LoadResourceViewModel<Resource, ResourceViewModel>
    
    @ObservedObject private var viewModel: ViewModel
    
    private let resourceView: (ResourceViewModel?) -> ResourceView
    private let loadingView: (LoadingState) -> ResourceLoadingView
    private let errorView: (ErrorState) -> ResourceErrorView
    
    init(
        viewModel: ViewModel,
        resourceView: @escaping (ResourceViewModel?) -> ResourceView,
        loadingView: @escaping (LoadingState) -> ResourceLoadingView,
        errorView: @escaping (ErrorState) -> ResourceErrorView
    ) {
        self.viewModel = viewModel
        self.resourceView = resourceView
        self.loadingView = loadingView
        self.errorView = errorView
    }
    
    var body: some View {
        VStack {
            errorView(viewModel.errorState)
            loadingView(viewModel.loadingState)
            resourceView(viewModel.resourceViewModel)
        }
    }
}

struct LoadResourceView_Demo: View {
    
    typealias Resource = String
    
    let isFailing: Bool
    
    var body: some View {
        let loader = {
            Just("This is a final state.")
                .delay(for: 2, scheduler: DispatchQueue.main)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
    
        let failingLoader: () -> AnyPublisher<Resource, Error> = {
            Fail(error: APIError())
                .delay(for: 2, scheduler: DispatchQueue.main)
                .eraseToAnyPublisher()
        }
    
        let viewModel = LoadResourceViewModel(
            errorState: .noError,
            loadingState: .init(isLoading: false),
            resourceViewModel: nil,//"initial state",
            loader: isFailing ? failingLoader : loader,
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
                ProgressView("LOADING")
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
        
        return LoadResourceView(
            viewModel: viewModel,
            resourceView: resourceView,
            loadingView: loadingView,
            errorView: errorView)
    }
}

private struct APIError: Error {}

struct LoadResourceView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LoadResourceView_Demo(isFailing: false)
            
            LoadResourceView_Demo(isFailing: true)
                .previewDisplayName("Failing Loader")
        }
        .preferredColorScheme(.dark)
    }
}

