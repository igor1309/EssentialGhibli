//
//  EssentialGhibliApp.swift
//  EssentialGhibli
//
//  Created by Igor Malyarov on 06.10.2022.
//

import SwiftUI

@main
struct EssentialGhibliApp: App {
    var body: some Scene {
        WindowGroup {
             ContentView(viewModel: .init())
//             UpdatableResourceStateView_Demo()
            // LoadResourceStateView_Demo(isFailing: true)
           // LoadResourceView_Demo(isFailing: false)
        }
    }
}
