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
    
    // TODO: Move test
//    func test_storageServiceSuccessfullyStoreStringAndRetrieveIt() {
//        let ex = expectation(description: "test_storageServiceSuccessfullyStoreStringAndRetrieveIt")
//        let key = "key"
//        let storedValue = "Pa$$w0rd"
//        var extractedValue: String?
//        var error: ErrorResponse?
//
//        SecureStorageService(secureStorage: storage.secureStorage).storeString(storedValue, forKey: key, onSuccess: {
//            SecureStorageService(secureStorage: storage.secureStorage).getString(forKey: key, onSuccess: { value in
//                extractedValue = value
//                ex.fulfill()
//            }) { e in
//                error = e
//                ex.fulfill()
//            }
//        }) { e in
//            error = e
//            ex.fulfill()
//        }
//
//        waitForExpectations(timeout: defaultTimeout) { (_) in
//            if error != nil {
//                XCTFail()
//            } else {
//                XCTAssertEqual(extractedValue, storedValue)
//            }
//        }
//    }
    
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
    
    // TODO: Move test
//    func test_storageServiceValueDoesNotExistGetString() {
//        let ex = expectation(description: "test_storageServiceValueDoesNotExistGetString")
//        let key = "noValueStoredHere"
//        var extractedValue: String?
//        var error: ErrorResponse?
//
//        SecureStorageService(secureStorage: storage.secureStorage).getString(forKey: key, onSuccess: { value in
//            extractedValue = value
//            ex.fulfill()
//        }) { e in
//            error = e
//            ex.fulfill()
//        }
//
//        waitForExpectations(timeout: defaultTimeout) { (_) in
//            if error != nil {
//                XCTFail()
//            } else {
//                XCTAssertNil(extractedValue)
//            }
//        }
//    }
    
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

    // TODO: Move test
//    func test_storageServiceSuccessfullyStoreValueAndRetrieveItThenRemoveIt() {
//        let ex = expectation(description: "test_storageServiceSuccessfullyStoreValueAndRetrieveItThenRemoveIt")
//        let key = "key"
//        let storedValue = "Pa$$w0rd"
//        var extractedValue: String?
//        var error: ErrorResponse?
//
//        SecureStorageService(secureStorage: storage.secureStorage).storeString(storedValue, forKey: key, onSuccess: {
//            SecureStorageService(secureStorage: storage.secureStorage).getString(forKey: key, onSuccess: { value in
//                if storedValue == value {
//                    SecureStorageService(secureStorage: storage.secureStorage).removeValue(forKey: key, onSuccess: {
//                        SecureStorageService(secureStorage: storage.secureStorage).getString(forKey: key, onSuccess: { value in
//                            extractedValue = value
//                            ex.fulfill()
//                        }) { e in
//                            error = e
//                            ex.fulfill()
//                        }
//                    }) { e in
//                        error = e
//                        ex.fulfill()
//                    }
//                }
//            }) { e in
//                error = e
//                ex.fulfill()
//            }
//        }) { e in
//            error = e
//            ex.fulfill()
//        }
//
//        waitForExpectations(timeout: defaultTimeout) { (_) in
//            if error != nil {
//                XCTFail()
//            } else {
//                XCTAssertNil(extractedValue)
//            }
//        }
//    }

    // TODO: Move test
//    func test_storageServiceSuccessfullyStoreValueThenRemoveItAndShouldBeNil() {
//        let ex = expectation(description: "test_storageServiceSuccessfullyStoreValueThenRemoveItAndShouldBeNil")
//        let key = "key"
//        let storedValue = "Pa$$w0rd"
//        var extractedValue: String?
//        var error: ErrorResponse?
//
//        SecureStorageService(secureStorage: storage.secureStorage).storeString(storedValue, forKey: key, onSuccess: {
//            SecureStorageService(secureStorage: storage.secureStorage).removeValue(forKey: key, onSuccess: {
//                SecureStorageService(secureStorage: storage.secureStorage).getString(forKey: key, onSuccess: { value in
//                    extractedValue = value
//                    ex.fulfill()
//                }) { e in
//                    error = e
//                    ex.fulfill()
//                }
//            }) { e in
//                error = e
//                ex.fulfill()
//            }
//        }) { e in
//            error = e
//            ex.fulfill()
//        }
//
//        waitForExpectations(timeout: defaultTimeout) { (_) in
//            if error != nil {
//                XCTFail()
//            } else {
//                XCTAssertNil(extractedValue)
//            }
//        }
//    }

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

    // TODO: Move test
//    func test_storageServiceSuccessfullyStoreValueThenCleanStorageAndShouldBeNil() {
//        let ex = expectation(description: "test_storageServiceSuccessfullyStoreValueThenCleanStorageAndShouldBeNil")
//        let key = "key"
//        let storedValue = "Pa$$w0rd"
//        var extractedValue: String?
//        var error: ErrorResponse?
//
//        SecureStorageService(secureStorage: storage.secureStorage).storeString(storedValue, forKey: key, onSuccess: {
//            SecureStorageService(secureStorage: storage.secureStorage).cleanStorage(onSuccess: {
//                SecureStorageService(secureStorage: storage.secureStorage).getString(forKey: key, onSuccess: { value in
//                    extractedValue = value
//                    ex.fulfill()
//                }) { e in
//                    error = e
//                    ex.fulfill()
//                }
//            }) { e in
//                error = e
//                ex.fulfill()
//            }
//        }) { e in
//            error = e
//            ex.fulfill()
//        }
//
//        waitForExpectations(timeout: defaultTimeout) { (_) in
//            if error != nil {
//                XCTFail()
//            } else {
//                XCTAssertNil(extractedValue)
//            }
//        }
//    }

    // TODO: Move test
//    func test_storageServiceSuccessfullyStoreObjectAndRetrieveIt() {
//        let ex = expectation(description: "test_storageServiceSuccessfullyStoreObjectAndRetrieveIt")
//        let key = "key"
//        let storedValue = CodableValueClass(id: 123, firstName: "firstName", lastName: "lastName")
//        var extractedValue: CodableValueClass?
//        var error: ErrorResponse?
//
//        SecureStorageService(secureStorage: storage.secureStorage).storeObject(storedValue, forKey: key, onSuccess: {
//            SecureStorageService(secureStorage: storage.secureStorage).getObject(forKey: key, onSuccess: { (value: CodableValueClass?) in
//                extractedValue = value
//                ex.fulfill()
//            }) { e in
//                error = e
//                ex.fulfill()
//            }
//        }) { e in
//            error = e
//            ex.fulfill()
//        }
//
//        waitForExpectations(timeout: defaultTimeout) { (_) in
//            if error != nil {
//                XCTFail()
//            } else {
//                expect(extractedValue).toNot(beNil())
//                expect(extractedValue?.id) == storedValue.id
//                expect(extractedValue?.firstName) == storedValue.firstName
//                expect(extractedValue?.lastName) == storedValue.lastName
//            }
//        }
//    }

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

    // TODO: Move test
//    func test_storageServiceValueDoesNotExistGetObject() {
//        let ex = expectation(description: "test_storageServiceValueDoesNotExistGetObject")
//        let key = "noValueStoredHere"
//        var extractedValue: Codable?
//        var error: ErrorResponse?
//
//        SecureStorageService(secureStorage: storage.secureStorage).getObject(forKey: key, onSuccess: { (value: CodableValueClass?) in
//            extractedValue = value
//            ex.fulfill()
//        }) { e in
//            error = e
//            ex.fulfill()
//        }
//
//        waitForExpectations(timeout: defaultTimeout) { (_) in
//            if error != nil {
//                XCTFail()
//            } else {
//                XCTAssertNil(extractedValue)
//            }
//        }
//    }

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
