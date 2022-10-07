//
//  ResourceView.swift
//  
//
//  Created by Igor Malyarov on 07.10.2022.
//

import SwiftUI

public struct ResourceStateView<Resource, ResourceView>: View
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
            
        case let .resource(resource):
            resourceView(resource)
            
        case let .error(error):
            errorView(error)
        }
    }
    
    private func loadingView() -> some View {
        ProgressView {
            Text("LOADING", tableName: "Localizable", bundle: .module)
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

struct ResourceStateView_Previews: PreviewProvider {
    static func loadableResourceView(
        _ resourceState: ResourceState<String, Error>
    ) -> some View {
        ResourceStateView(resourceState: resourceState) {
            Text($0)
        }
    }
    static var previews: some View {
        Group {
            loadableResourceView(.loading)
                .environment(\.locale, .en_US)
                .previewDisplayName("en | Loading")
         
            loadableResourceView(.loading)
                .environment(\.locale, .ru_RU)
                .previewDisplayName("ru | Loading")
         
            loadableResourceView(.resource("This is a real value."))
                .previewDisplayName("Value")
          
            loadableResourceView(.error(APIError()))
                .previewDisplayName("Error")
        }
        .preferredColorScheme(.dark)
    }
}

private struct APIError: Error {}

private extension Locale {
    static let en_US: Self = .init(identifier: "en-US")
    static let ru_RU: Self = .init(identifier: "ru-RU")
}
