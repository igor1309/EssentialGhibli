//
//  LoadResourceView.swift
//  EssentialGhibli
//
//  Created by Igor Malyarov on 08.10.2022.
//

import Combine
import Presentation
import SwiftUI

public struct LoadResourceView<
    Resource,
    ResourceView,
    ResourceLoadingView,
    ResourceErrorView>: View
where ResourceView: View,
      ResourceLoadingView: View,
      ResourceErrorView: View {
    
    public typealias ViewModel = LoadResourceViewModel<Resource>
    
    @ObservedObject private var viewModel: ViewModel
    
    private let resourceView: (Resource) -> ResourceView
    private let loadingView: (LoadingState) -> ResourceLoadingView
    private let errorView: (ErrorState) -> ResourceErrorView
    
    public init(
        viewModel: ViewModel,
        resourceView: @escaping (Resource) -> ResourceView,
        loadingView: @escaping (LoadingState) -> ResourceLoadingView,
        errorView: @escaping (ErrorState) -> ResourceErrorView
    ) {
        self.viewModel = viewModel
        self.resourceView = resourceView
        self.loadingView = loadingView
        self.errorView = errorView
    }
    
    public var body: some View {
        VStack {
            errorView(viewModel.errorState)
            loadingView(viewModel.loadingState)
            viewModel.resource.map(resourceView)
        }
    }
}

public final class LoadResourceViewModel<Resource>: ObservableObject {
    
    @Published private(set) var errorState: ErrorState
    @Published private(set) var loadingState: LoadingState
    @Published private(set) var resource: Resource?
    
    private let loader: () -> AnyPublisher<Resource, Error>
    private var cancellable: Cancellable?
    
    public init(
        errorState: ErrorState = .noError,
        loadingState: LoadingState = .init(isLoading: false),
        resource: Resource? = nil,
        loader: @escaping () -> AnyPublisher<Resource, Error>
    ) {
        self.errorState = errorState
        self.loadingState = loadingState
        self.resource = resource
        self.loader = loader
        
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
        self.resource = resource
        loadingState = .init(isLoading: false)
    }
    
    private func didFinishLoading(with error: Error) {
        // or map to another error
        errorState = .error(message: error.localizedDescription)
        loadingState = .init(isLoading: false)
    }
}

#if DEBUG
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
            resource: nil,//"initial state",
            loader: isFailing ? failingLoader : loader
        )

        func resourceView(resource: Resource?) -> some View {
            resource.map(Text.init(verbatim:))
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

        return LoadResourceView(
            viewModel: viewModel,
            resourceView: resourceView,
            loadingView: loadingView,
            errorView: errorView
        )
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
#endif
