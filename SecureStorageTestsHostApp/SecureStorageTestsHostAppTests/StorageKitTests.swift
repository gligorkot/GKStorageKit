//
//  StorageKitTests.swift
//  GKStorageKitTests
//
//  Created by Gligor Kotushevski on 20/03/17.
//  Copyright © 2017 Gligor Kotushevski. All rights reserved.
//

import XCTest
import Valet
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
        XCTAssertNotNil(StorageKitConfiguration.shared.storage)
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
                XCTAssertNotNil(extractedValue)
                XCTAssertEqual(extractedValue, storedValue)
            }
        }
    }
    
    func test_storageKitSuccessfullyCleanStorages() {
        let ex = expectation(description: "test_storageKitSuccessfullyCleanStorages")
        var cleared: Bool = false
        
        StorageKit.cleanupStorages {
            cleared = true
            ex.fulfill()
        }

        waitForExpectations(timeout: defaultTimeout) { (_) in
            XCTAssertTrue(cleared)
        }
    }

    func test_storageKitErrorCleanSecureStorage() {
        // override the setUp
        StorageKit.initStorageKit(storage: ErrorStorage())
        let ex = expectation(description: "test_storageKitErrorCleanSecureStorage")
        var cleared: Bool = false

        StorageKit.cleanupStorages {
            cleared = true
            ex.fulfill()
        }

        waitForExpectations(timeout: defaultTimeout) { (_) in
            XCTAssertTrue(cleared)
        }
    }

}
