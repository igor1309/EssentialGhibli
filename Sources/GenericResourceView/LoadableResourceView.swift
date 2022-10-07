//
//  ResourceView.swift
//  
//
//  Created by Igor Malyarov on 07.10.2022.
//

import SwiftUI

public struct LoadableResourceView<Resource, ResourceView>: View
where ResourceView: View {
    
    private let resourceState: ResourceState<Resource, Error>
    private let resourceView: (Resource) -> ResourceView
    
    public init(
        resourceState: ResourceState<Resource, Error>,
        resourceView: @escaping (Resource) -> ResourceView
    ) {
        self.resourceState = resourceState
        self.resourceView = resourceView
    }
    
    public var body: some View {
        switch resourceState {
        case .loading:
            loadingView()
            
        case let .detail(resource):
            resourceView(resource)
            
        case let .error(error):
            errorView(error)
        }
    }
    
    private func loadingView() -> some View {
        ProgressView {
            Text("LOADING", tableName: "Detail", bundle: .module)
        }
    }
    
    private func errorView(_ error: Error) -> some View {
        Text(error.localizedDescription)
            .foregroundColor(.white)
            .padding()
            .background(.red)
            .cornerRadius(24)
            .padding()
    }
}
