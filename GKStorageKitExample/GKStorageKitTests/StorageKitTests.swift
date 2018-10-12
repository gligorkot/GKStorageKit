//
//  StorageKitTests.swift
//  GKStorageKitTests
//
//  Created by Gligor Kotushevski on 20/03/17.
//  Copyright © 2017 Gligor Kotushevski. All rights reserved.
//

import XCTest
import Nimble
import Valet
import SwiftTestUtils
@testable import GKStorageKit
@testable import GKBaseKit

class StorageKitTests: XCTestCase {
    
    override func setUp() {
        StorageKit.initStorageKit()
    }
    
    override func tearDown() {
        let semaphore = DispatchSemaphore(value: 0)
        StorageKit.cleanupStorages {
            StorageKitConfiguration.tearDownConfig()
            semaphore.signal()
        }
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
    }

    func test_storageKitParamsNotNilForDefaultStorage() {
        expect(StorageKitConfiguration.shared.storage).toNot(beNil())
    }
    
    func test_storageKitSuccessfullyStoreValueAndRetrieveIt() {
        let ex = expectation(description: "test_storageKitSuccessfullyStoreValueAndRetrieveIt")
        let key = "key"
        let storedValue = "Pa$$w0rd"
        var extractedValue: String?
        var error: ErrorResponse?
        
        StorageKit.secureStorage.storeString(storedValue, forKey: key, onSuccess: {
            StorageKit.secureStorage.getString(forKey: key, onSuccess: { value in
                extractedValue = value
                ex.fulfill()
            }) { e in
                error = e
                ex.fulfill()
            }
        }) { e in
            error = e
            ex.fulfill()
        }
        
        waitForExpectations(timeout: defaultTimeout) { (_) in
            if error != nil {
                XCTFail()
            } else {
                expect(extractedValue).toNot(beNil())
                expect(extractedValue) == storedValue
            }
        }
    }
    
    func test_storageKitSuccessfullyCleanStorages() {
        let ex = expectation(description: "test_storageKitSuccessfullyCleanStorages")

        StorageKit.cleanupStorages {
            ex.fulfill()
        }

        waitForExpectations(timeout: defaultTimeout) { (_) in
            expect(true) == true
        }
    }

    func test_storageKitErrorCleanSecureStorage() {
        // override the setUp
        StorageKit.initStorageKit(storage: ErrorStorage())
        let ex = expectation(description: "test_storageKitErrorCleanSecureStorage")

        StorageKit.cleanupStorages {
            ex.fulfill()
        }

        waitForExpectations(timeout: defaultTimeout) { (_) in
            expect(true) == true
        }
    }

}
