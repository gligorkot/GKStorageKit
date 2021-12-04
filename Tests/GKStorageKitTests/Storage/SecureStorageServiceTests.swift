//
//  SecureStorageServiceTests.swift
//  GKStorageKitTests
//
//  Created by Gligor Kotushevski on 20/03/17.
//  Copyright © 2017 Gligor Kotushevski. All rights reserved.
//

import XCTest
import Valet
@testable import GKStorageKit
@testable import GKBaseKit

class SecureStorageServiceTests: XCTestCase, StorageKitDecorator {
    
    override func setUp() {
        StorageKit.initStorageKit(storage: TestStorage())
    }
    
    override func tearDown() {
        let semaphore = DispatchSemaphore(value: 0)
        StorageKit.cleanupStorages {
            StorageKitConfiguration.tearDownConfig()
            semaphore.signal()
        }
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
    }
    
    func test_storageServiceErrorStoreString() {
        // override the setUp
        StorageKit.initStorageKit(storage: ErrorStorage())

        let ex = expectation(description: "test_storageServiceErrorStoreString")
        let key = "key"
        let storedValue = "Pa$$w0rd"
        var error: ErrorResponse?
        
        SecureStorageService(secureStorage: storage.secureStorage).storeString(storedValue, forKey: key, onSuccess: {
            ex.fulfill()
        }) { e in
            error = e
            ex.fulfill()
        }
        
        waitForExpectations(timeout: defaultTimeout) { (_) in
            if let error = error {
                XCTAssertEqual(error.title, "Storage")
                XCTAssertEqual(error.message, "Cannot save secure value. Keychain inaccessible.")
            } else {
                XCTFail()
            }
        }
    }

    func test_storageServiceErrorStoreEmptyString() {
        let ex = expectation(description: "test_storageServiceErrorStoreEmptyString")
        let key = "key"
        let storedValue = ""
        var error: ErrorResponse?

        SecureStorageService(secureStorage: storage.secureStorage).storeString(storedValue, forKey: key, onSuccess: {
            ex.fulfill()
        }) { e in
            error = e
            ex.fulfill()
        }

        waitForExpectations(timeout: defaultTimeout) { (_) in
            if let error = error {
                XCTAssertEqual(error.title, "Storage")
                XCTAssertEqual(error.message, "Cannot save secure value. Keychain inaccessible.")
            } else {
                XCTFail()
            }
        }
    }
    
    func test_storageServiceKeychainInaccessibleErrorGetString() {
        // override the setUp
        StorageKit.initStorageKit(storage: ErrorStorage())

        let ex = expectation(description: "test_storageServiceKeychainInaccessibleErrorGetString")
        let key = "key"
        var extractedValue: String?
        var error: ErrorResponse?

        SecureStorageService(secureStorage: storage.secureStorage).getString(forKey: key, onSuccess: { value in
            extractedValue = value
            ex.fulfill()
        }) { e in
            error = e
            ex.fulfill()
        }

        waitForExpectations(timeout: defaultTimeout) { (_) in
            if let error = error {
                XCTAssertNil(extractedValue)
                XCTAssertEqual(error.title, "Storage")
                XCTAssertEqual(error.message, "Cannot retrieve secure value. Keychain inaccessible.")
            } else {
                XCTFail()
            }
        }
    }

    func test_storageServiceErrorRemoveValue() {
        // override the setUp
        StorageKit.initStorageKit(storage: ErrorStorage())

        let ex = expectation(description: "test_storageServiceErrorRemoveValue")
        let key = "key"
        var error: ErrorResponse?

        SecureStorageService(secureStorage: storage.secureStorage).removeValue(forKey: key, onSuccess: {
            ex.fulfill()
        }) { e in
            error = e
            ex.fulfill()
        }

        waitForExpectations(timeout: defaultTimeout) { (_) in
            if let error = error {
                XCTAssertEqual(error.title, "Storage")
                XCTAssertEqual(error.message, "Cannot remove secure value. Keychain inaccessible.")
            } else {
                XCTFail()
            }
        }
    }

    func test_storageServiceErrorCleanSecureStorage() {
        // override the setUp
        StorageKit.initStorageKit(storage: ErrorStorage())

        let ex = expectation(description: "test_storageServiceErrorCleanSecureStorage")
        var error: ErrorResponse?

        SecureStorageService(secureStorage: storage.secureStorage).cleanStorage(onSuccess: {
            ex.fulfill()
        }) { e in
            error = e
            ex.fulfill()
        }

        waitForExpectations(timeout: defaultTimeout) { (_) in
            if let error = error {
                XCTAssertEqual(error.title, "Storage")
                XCTAssertEqual(error.message, "Cannot clean secure storage. Keychain inaccessible.")
            } else {
                XCTFail()
            }
        }
    }

    func test_storageServiceErrorStoreObject() {
        // override the setUp
        StorageKit.initStorageKit(storage: ErrorStorage())

        let ex = expectation(description: "test_storageServiceErrorStoreObject")
        let key = "key"
        let storedValue = CodableValueClass(id: 123, firstName: "firstName", lastName: "lastName")
        var error: ErrorResponse?

        SecureStorageService(secureStorage: storage.secureStorage).storeObject(storedValue, forKey: key, onSuccess: {
            ex.fulfill()
        }) { e in
            error = e
            ex.fulfill()
        }

        waitForExpectations(timeout: defaultTimeout) { (_) in
            if let error = error {
                XCTAssertEqual(error.title, "Storage")
                XCTAssertEqual(error.message, "Cannot save secure value. Keychain inaccessible.")
            } else {
                XCTFail()
            }
        }
    }

    func test_storageServiceKeychainInaccessibleErrorGetObject() {
        // override the setUp
        StorageKit.initStorageKit(storage: ErrorStorage())

        let ex = expectation(description: "test_storageServiceKeychainInaccessibleErrorGetObject")
        let key = "key"
        var extractedValue: Codable?
        var error: ErrorResponse?

        SecureStorageService(secureStorage: storage.secureStorage).getObject(forKey: key, onSuccess: { (value: CodableValueClass?) in
            extractedValue = value
            ex.fulfill()
        }) { e in
            error = e
            ex.fulfill()
        }

        waitForExpectations(timeout: defaultTimeout) { (_) in
            if let error = error {
                XCTAssertNil(extractedValue)
                XCTAssertEqual(error.title, "Storage")
                XCTAssertEqual(error.message, "Cannot retrieve secure value. Keychain inaccessible.")
            } else {
                XCTFail()
            }
        }
    }

}
