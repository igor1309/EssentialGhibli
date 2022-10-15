//
//  EssentialGhibliApp.swift
//  EssentialGhibli
//
//  Created by Igor Malyarov on 06.10.2022.
//

import API
import Combine
import CacheInfra
import SharedAPI
import SharedAPIInfra
import SwiftUI

@main
struct EssentialGhibliApp: App {
    
    var body: some Scene {
        WindowGroup {
//            UIComposer(loaderComposer: LoaderComposer<CoreDataFeedStore>())
            
//            LoadingImageView(loader: {
//                Just((.greenImage(width: 300, height: 600), .any200))
//                    .setFailureType(to: Error.self)
//                    .map { try! ImageMapper.map(dataResponse: $0) }
//                    .eraseToAnyPublisher()
//            })
            
              ContentViewComposer()
            
            // UpdatableResourceStateView_Demo()
            // LoadResourceStateView_Demo(isFailing: true)
            // LoadResourceView_Demo(isFailing: false)
        }
    }
}
