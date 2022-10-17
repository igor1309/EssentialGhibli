//
//  ImageErrorView.swift
//  EssentialGhibli
//
//  Created by Igor Malyarov on 13.10.2022.
//

import Presentation
import SwiftUI

struct ImageErrorView: View {
    let errorState: ErrorState
    let font: Font?
    
    init(errorState: ErrorState, font: Font? = .caption) {
        self.errorState = errorState
        self.font = font
    }
    
    var body: some View {
        switch errorState {
        case .noError:
            EmptyView()
            
        case let .error(message: message):
            VStack {
                Image(systemName: "exclamationmark.triangle")
                    .resizable()
                    .scaledToFit()
                    .symbolRenderingMode(.multicolor)
                
                font.map { font in
                    Text(message)
                        .font(font)
                }
            }
        }
    }
}

#if DEBUG
struct ImageErrorView_Previews: PreviewProvider {
    static func imageErrorView(
        errorState: ErrorState,
        _ width: CGFloat,
        _ font: Font?
    ) -> some View {
        ImageErrorView(errorState: errorState, font: font)
            .frame(width: width, height: width)
            .border(.blue, width: 0.5)
    }
    
    static var previews: some View {
        Group {
            VStack {
                // empty view not visible
                imageErrorView(errorState: .noError, 64, .caption)
                
                imageErrorView(errorState: .error, 64, nil)
                imageErrorView(errorState: .error, 64, nil)
                    .foregroundColor(.red)
                imageErrorView(errorState: .error, 64, .caption)
                    .foregroundColor(.red)
                imageErrorView(errorState: .error, 256, .headline)
                    .foregroundStyle(.yellow)
            }
            
            ImageErrorView(errorState: .error, font: .title)
        }
        .preferredColorScheme(.dark)
    }
}

private extension ErrorState {
    static let error: Self = .error(message: "Can't load image")
}
#endif
