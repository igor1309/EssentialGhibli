//
//  ErrorView.swift
//  EssentialGhibli
//
//  Created by Igor Malyarov on 14.10.2022.
//

import Presentation
import SwiftUI

struct ErrorView: View {
    let errorState: ErrorState
    
    var body: some View {
        if case let .error(message) = errorState {
            Text(message)
                .foregroundStyle(.red)
        }
    }
}

struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // empty View is hidden
            ErrorView(errorState: .noError)
            
            ErrorView(errorState: .error(message: "Error loading film list"))
        }
        .preferredColorScheme(.dark)
    }
}
