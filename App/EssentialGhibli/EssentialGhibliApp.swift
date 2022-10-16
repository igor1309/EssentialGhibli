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
            UIComposer(loader: .online)
            // ContentViewComposer()
        }
    }
}
