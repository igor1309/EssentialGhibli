//
//  ProgressLoadingView.swift
//  EssentialGhibli
//
//  Created by Igor Malyarov on 14.10.2022.
//

import Presentation
import SwiftUI

struct ProgressLoadingView: View {
    let loadingState: LoadingState
    
    var body: some View {
        if loadingState.isLoading {
            ProgressView {
                Text("LOADING", tableName: "Localizable", bundle: .main)
            }
        }
    }
}

#if DEBUG
struct ProgressLoadingView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // non loading view is hidden
            ProgressLoadingView(loadingState: .init(isLoading: false))
            
            ProgressLoadingView(loadingState: .init(isLoading: true))
                .environment(\.locale, .en_US)
                .previewDisplayName(Locale.en_US.identifier)
            
            ProgressLoadingView(loadingState: .init(isLoading: true))
                .environment(\.locale, .ru_RU)
                .previewDisplayName(Locale.ru_RU.identifier)
        }
        .preferredColorScheme(.dark)
    }
}
#endif
