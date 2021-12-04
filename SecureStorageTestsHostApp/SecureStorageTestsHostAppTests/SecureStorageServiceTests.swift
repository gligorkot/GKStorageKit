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
    
    func test_storageServiceSuccessfullyStoreStringAndRetrieveIt() {
        let ex = expectation(description: "test_storageServiceSuccessfullyStoreStringAndRetrieveIt")
        let key = "key"
        let storedValue = "Pa$$w0rd"
        var extractedValue: String?
        var error: ErrorResponse?

        SecureStorageService(secureStorage: storage.secureStorage).storeString(storedValue, forKey: key, onSuccess: {
            SecureStorageService(secureStorage: storage.secureStorage).getString(forKey: key, onSuccess: { value in
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
                XCTAssertEqual(extractedValue, storedValue)
            }
        }
    }
    
    func test_storageServiceValueDoesNotExistGetString() {
        let ex = expectation(description: "test_storageServiceValueDoesNotExistGetString")
        let key = "noValueStoredHere"
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
            if error != nil {
                XCTFail()
            } else {
                XCTAssertNil(extractedValue)
            }
        }
    }

    func test_storageServiceSuccessfullyStoreValueAndRetrieveItThenRemoveIt() {
        let ex = expectation(description: "test_storageServiceSuccessfullyStoreValueAndRetrieveItThenRemoveIt")
        let key = "key"
        let storedValue = "Pa$$w0rd"
        var extractedValue: String?
        var error: ErrorResponse?

        SecureStorageService(secureStorage: storage.secureStorage).storeString(storedValue, forKey: key, onSuccess: {
            SecureStorageService(secureStorage: storage.secureStorage).getString(forKey: key, onSuccess: { value in
                if storedValue == value {
                    SecureStorageService(secureStorage: storage.secureStorage).removeValue(forKey: key, onSuccess: {
                        SecureStorageService(secureStorage: storage.secureStorage).getString(forKey: key, onSuccess: { value in
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
                }
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
                XCTAssertNil(extractedValue)
            }
        }
    }

    func test_storageServiceSuccessfullyStoreValueThenRemoveItAndShouldBeNil() {
        let ex = expectation(description: "test_storageServiceSuccessfullyStoreValueThenRemoveItAndShouldBeNil")
        let key = "key"
        let storedValue = "Pa$$w0rd"
        var extractedValue: String?
        var error: ErrorResponse?

        SecureStorageService(secureStorage: storage.secureStorage).storeString(storedValue, forKey: key, onSuccess: {
            SecureStorageService(secureStorage: storage.secureStorage).removeValue(forKey: key, onSuccess: {
                SecureStorageService(secureStorage: storage.secureStorage).getString(forKey: key, onSuccess: { value in
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
        }) { e in
            error = e
            ex.fulfill()
        }

        waitForExpectations(timeout: defaultTimeout) { (_) in
            if error != nil {
                XCTFail()
            } else {
                XCTAssertNil(extractedValue)
            }
        }
    }

    func test_storageServiceSuccessfullyStoreValueThenCleanStorageAndShouldBeNil() {
        let ex = expectation(description: "test_storageServiceSuccessfullyStoreValueThenCleanStorageAndShouldBeNil")
        let key = "key"
        let storedValue = "Pa$$w0rd"
        var extractedValue: String?
        var error: ErrorResponse?

        SecureStorageService(secureStorage: storage.secureStorage).storeString(storedValue, forKey: key, onSuccess: {
            SecureStorageService(secureStorage: storage.secureStorage).cleanStorage(onSuccess: {
                SecureStorageService(secureStorage: storage.secureStorage).getString(forKey: key, onSuccess: { value in
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
        }) { e in
            error = e
            ex.fulfill()
        }

        waitForExpectations(timeout: defaultTimeout) { (_) in
            if error != nil {
                XCTFail()
            } else {
                XCTAssertNil(extractedValue)
            }
        }
    }

    func test_storageServiceSuccessfullyStoreObjectAndRetrieveIt() {
        let ex = expectation(description: "test_storageServiceSuccessfullyStoreObjectAndRetrieveIt")
        let key = "key"
        let storedValue = CodableValueClass(id: 123, firstName: "firstName", lastName: "lastName")
        var extractedValue: CodableValueClass?
        var error: ErrorResponse?

        SecureStorageService(secureStorage: storage.secureStorage).storeObject(storedValue, forKey: key, onSuccess: {
            SecureStorageService(secureStorage: storage.secureStorage).getObject(forKey: key, onSuccess: { (value: CodableValueClass?) in
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
                XCTAssertEqual(extractedValue?.id, storedValue.id)
                XCTAssertEqual(extractedValue?.firstName, storedValue.firstName)
                XCTAssertEqual(extractedValue?.lastName, storedValue.lastName)
            }
        }
    }

    func test_storageServiceValueDoesNotExistGetObject() {
        let ex = expectation(description: "test_storageServiceValueDoesNotExistGetObject")
        let key = "noValueStoredHere"
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
            if error != nil {
                XCTFail()
            } else {
                XCTAssertNil(extractedValue)
            }
        }
    }

}
