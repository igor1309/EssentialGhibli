//
//  DetailNavigationComposerSnapshotTests.swift
//  EssentialGhibliTests
//
//  Created by Igor Malyarov on 15.10.2022.
//

import Combine
@testable import EssentialGhibli
import ListFeature
import SwiftUI
import XCTest

final class DetailNavigationComposerSnapshotTests: XCTestCase {
    let record = false
    
    func test_shouldShowEmptyList_onEmptyLoader() {
        let sut = detailNavigationComposer(PreviewLoaders.emptyListFilmsLoader)
        
        assert(snapshot: sut, locale: .en_US, record: record)
        assert(snapshot: sut, locale: .ru_RU, record: record)
    }
    
    func test_shouldShowEmptyList_onEmptyLoaderComposer() {
        let sut = detailNavigationComposer(loader: LoaderComposer.empty)
        
        assert(snapshot: sut, locale: .en_US, record: record)
        assert(snapshot: sut, locale: .ru_RU, record: record)
    }
    
    func test_shouldShowFilmList_onSuccessLoader() {
        let sut = detailNavigationComposer(PreviewLoaders.listFilmsLoader)
        
        assert(snapshot: sut, locale: .en_US, record: record)
    }
    
    func test_shouldShowFilmList_onOnlineLoader() {
        let sut = detailNavigationComposer(LoaderComposer.online.filmsLoader)
                
        assert(snapshot: sut, locale: .en_US, record: record)
    }
    
    func test_shouldShowFilmList_withActiveRows_onSuccessLoader() {
        let sut = NavigationView {
            detailNavigationComposer(PreviewLoaders.listFilmsLoader)
        }
        
        assert(snapshot: sut, locale: .en_US, record: record)
    }
    
    func test_shouldShowFilmList_withActiveRows_onOnlineLoader() {
        let sut = NavigationView {
            detailNavigationComposer(LoaderComposer.online.filmsLoader)
        }
        
        assert(snapshot: sut, locale: .en_US, record: record)
    }
    
    func test_shouldShowLoading_onLongLoader() {
        let sut = detailNavigationComposer(PreviewLoaders.longListFilmsLoader)
        
        assert(snapshot: sut, locale: .en_US, record: record)
        assert(snapshot: sut, locale: .ru_RU, record: record)
    }
    
    func test_shouldShowLoading_onLongOnlineLoader() {
        let sut = detailNavigationComposer(LoaderComposer.online.longFilmsLoader)
        
        assert(snapshot: sut, locale: .en_US, record: record)
        assert(snapshot: sut, locale: .ru_RU, record: record)
    }
    
    func test_shouldShowError_onFailingLoader() {
        let sut = detailNavigationComposer(PreviewLoaders.failingListFilmsLoader)
        
        assert(snapshot: sut, locale: .en_US, record: record)
        assert(snapshot: sut, locale: .ru_RU, record: record)
    }
}
