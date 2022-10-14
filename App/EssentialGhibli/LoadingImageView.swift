//
//  LoadingImageView.swift
//  EssentialGhibli
//
//  Created by Igor Malyarov on 13.10.2022.
//

import Combine
import GenericResourceView
import Presentation
import SwiftUI

typealias DataResponse = (data: Data, response: HTTPURLResponse)
typealias ImagePublisher = AnyPublisher<Image, Error>

struct LoadingImageView: View {
    var showLabel: Bool = true
    let loader: () -> ImagePublisher
    
    var body: some View {
        LoadResourceView(
            viewModel: .init(loader: loader),
            resourceView: resourceView,
            loadingView: loadingView,
            errorView: errorView
        )
    }
    
    private func resourceView(image: Image) -> some View {
        image.resizable().scaledToFit()
    }
    
    @ViewBuilder
    func loadingView(loadingState: LoadingState) -> some View {
        if loadingState.isLoading {
//            Color.clear
//                .overlay {
                    ProgressView {
                        if showLabel {
                            Text("LOADING", tableName: "Localizable", bundle: .main)
                        }
                    }
//                }
        }
    }

    private func errorView(errorState: ErrorState) -> some View {
        ImageErrorView(errorState: errorState, font: nil)
            .foregroundColor(.red)
    }
}

#if DEBUG
struct LoadingImageView_Demo: View {
    func loader() -> ImagePublisher {
        Just((.greenImage(width: 300, height: 600), .any200))
            .delay(for: 2, scheduler: DispatchQueue.main)
            .tryMap(ImageMapper.map)
            .eraseToAnyPublisher()
    }
    
    func longLoader() -> ImagePublisher {
        loader()
            .delay(for: 10, scheduler: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func non200Loader() -> ImagePublisher {
        Just((.greenImage(width: 300, height: 600), .any400))
            .delay(for: 2, scheduler: DispatchQueue.main)
            .tryMap(ImageMapper.map)
            .eraseToAnyPublisher()
    }
    
    func failingLoader() -> ImagePublisher {
        Fail<DataResponse, Error>(error: anyError())
            .delay(for: 2, scheduler: DispatchQueue.main)
            .tryMap(ImageMapper.map)
            .eraseToAnyPublisher()
    }
    
    var body: some View {
        VStack {
            Group {
                LoadingImageView(loader: loader)
                LoadingImageView(showLabel: false, loader: loader)

                LoadingImageView(loader: longLoader)
                LoadingImageView(showLabel: false, loader: longLoader)

                LoadingImageView(loader: non200Loader)
                LoadingImageView(showLabel: false, loader: non200Loader)

                LoadingImageView(loader: failingLoader)
            }
            .border(.blue, width: 0.5)
        }
    }
}

struct LoadingImageView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LoadingImageView_Demo()
                .frame(width: 240, height: 240)
            
            LoadingImageView_Demo()
                .frame(width: 600, height: 600)
        }
        .preferredColorScheme(.dark)
    }
}

private extension Data {
    static let empty: Self = Data("".utf8)
    
    static func greenImage(width: Int, height: Int) -> Data {
        uiImageData(withColor: .green, width: width, height: height)
    }
    
    static func uiImageData(
        withColor color: UIColor,
        width: Int,
        height: Int
    ) -> Data {
        UIImage.make(withColor: color, width: width, height: height).pngData()!
    }
}

private extension HTTPURLResponse {
    static let any200: HTTPURLResponse = .init(url: .anyURL, statusCode: 200, httpVersion: nil, headerFields: nil)!
    static let any400: HTTPURLResponse = .init(url: .anyURL, statusCode: 400, httpVersion: nil, headerFields: nil)!
}

private extension URL {
    static let anyURL: URL = .init(string: "https://any-url.com")!
}

private extension UIImage {
    static func make(
        withColor color: UIColor,
        width: Int = 1,
        height: Int = 1
    ) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: width, height: height)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()!
        context.setFillColor(color.cgColor)
        context.fill(rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
    }
}
#endif
