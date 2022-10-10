//
//  FeedStoreSpecs.swift
//  
//
//  Created by Igor Malyarov on 10.10.2022.
//

import Foundation

protocol FeedStoreSpecs {
    func test_retrieve_shouldDeliverEmptyOnEmptyCache()
    func test_retrieve_shouldHaveNoSideEffectsOnEmptyCache()
    func test_retrieve_shouldDeliverInsertedValues()
    func test_retrieve_shouldHaveNoSideEffectsOnNonEmptyCache()

    func test_insert_shouldDeliverNoErrorOnEmptyCache()
    func test_insert_shouldDeliverNoErrorOnNonEmptyCache()
    func test_insert_shouldOverridePreviouslyInsertedCache()

    func test_delete_shouldHaveNoSideEffectsOnEmptyCache()
    func test_delete_shouldEmptyPreviouslyInsertedCache()
}

protocol FailableRetrieveFeedStoreSpecs: FeedStoreSpecs {
    func test_retrieve_shouldDeliverErrorOnRetrievalFailure()
    func test_retrieve_shouldHaveNoSideEffectsOnRetrievalFailure()
}

protocol FailableInsertFeedStoreSpecs: FeedStoreSpecs {
    func test_insert_shouldDeliverErrorOnInsertionFailure()
    func test_insert_shouldHaveNoSideEffectsOnInsertionError()
}

protocol FailableDeleteFeedStoreSpecs: FeedStoreSpecs {
    func test_delete_shouldDeliverErrorOnDeletionFailure()
    func test_delete_shouldHaveNoSideEffectsOnDeletionError()
}

typealias FailableFeedStore = FailableRetrieveFeedStoreSpecs & FailableInsertFeedStoreSpecs & FailableDeleteFeedStoreSpecs
