//
//  ObjectStorageServiceTests.swift
//  GKStorageKitTests
//
//  Created by Gligor Kotushevski on 20/03/17.
//  Copyright © 2017 Gligor Kotushevski. All rights reserved.
//

import XCTest
@testable import GKStorageKit

class ObjectStorageServiceTests: XCTestCase {
    
    private var objectStorageService: ObjectStorageService!
    
    override func setUp() {
        StorageKit.initStorageKit(storage: TestStorage())
        objectStorageService = ObjectStorageService(storage: StorageKitConfiguration.shared.storage.userDefaults)
    }
    
    override func tearDown() {
        objectStorageService.cleanStorage(onSuccess: {
            StorageKitConfiguration.tearDownConfig()
        })
    }
    
    func test_storageServiceSuccessfullyStoreArrayOfCodablesAndRetrieveIt() {
        let ex = expectation(description: "test_storageServiceSuccessfullyStoreArrayOfCodablesAndRetrieveIt")
        let key = "key"
        let storable = CodableValueClass(id: 123, firstName: "firstName", lastName: "lastName")
        let storedValue = [storable]
        var extractedValue: [Codable]?
        let error: StorageError? = nil
        
        objectStorageService.storeCollection(storedValue, forKey: key, onSuccess: {
            self.objectStorageService.getCollection(forKey: key, onSuccess: { (value: [CodableValueClass]?) in
                extractedValue = value
                ex.fulfill()
            })
        })
        
        waitForExpectations(timeout: defaultTimeout) { (_) in
            if error != nil {
                XCTFail()
            } else {
                XCTAssertEqual(extractedValue?.count, storedValue.count)
                if let firstCaller = extractedValue?.first as? CodableValueClass {
                    XCTAssertEqual(firstCaller.id, storedValue.first!.id)
                } else {
                    XCTFail()
                }
            }
        }
    }

    func test_storageServiceValueDoesNotExistGetCollection() {
        let ex = expectation(description: "test_storageServiceValueDoesNotExistGetCollection")
        let key = "noValueStoredHere"
        var extractedValue: [Codable]?
        let error: StorageError? = nil
        
        objectStorageService.getCollection(forKey: key, onSuccess: { (value: [CodableValueClass]?) in
            extractedValue = value
            ex.fulfill()
        })
        
        waitForExpectations(timeout: defaultTimeout) { (_) in
            if error != nil {
                XCTFail()
            } else {
                XCTAssertNil(extractedValue)
            }
        }
    }

    func test_storageServiceSuccessfullyStoreCollectionAndRetrieveItThenRemoveIt() {
        let ex = expectation(description: "test_storageServiceSuccessfullyStoreCollectionAndRetrieveItThenRemoveIt")
        let key = "key"
        let storable = CodableValueClass(id: 123, firstName: "firstName", lastName: "lastName")
        let storedValue = [storable]
        var extractedValue: [Codable]?
        let error: StorageError? = nil
        
        objectStorageService.storeCollection(storedValue, forKey: key, onSuccess: {
            self.objectStorageService.getCollection(forKey: key, onSuccess: { (value: [CodableValueClass]?) in
                if storedValue.count == value?.count {
                    self.objectStorageService.removeValue(forKey: key, onSuccess: {
                        self.objectStorageService.getCollection(forKey: key, onSuccess: { (value: [CodableValueClass]?) in
                            extractedValue = value
                            ex.fulfill()
                        })
                    })
                }
            })
        })
        
        waitForExpectations(timeout: defaultTimeout) { (_) in
            if error != nil {
                XCTFail()
            } else {
                XCTAssertNil(extractedValue)
            }
        }
    }

    func test_storageServiceSuccessfullyStoreCollectionThenRemoveItAndShouldBeNil() {
        let ex = expectation(description: "test_storageServiceSuccessfullyStoreCollectionThenRemoveItAndShouldBeNil")
        let key = "key"
        let storable = CodableValueClass(id: 123, firstName: "firstName", lastName: "lastName")
        let storedValue = [storable]
        var extractedValue: [Codable]?
        let error: StorageError? = nil
        
        objectStorageService.storeCollection(storedValue, forKey: key, onSuccess: {
            self.objectStorageService.removeValue(forKey: key, onSuccess: {
                self.objectStorageService.getCollection(forKey: key, onSuccess: { (value: [CodableValueClass]?) in
                    extractedValue = value
                    ex.fulfill()
                })
            })
        })
        
        waitForExpectations(timeout: defaultTimeout) { (_) in
            if error != nil {
                XCTFail()
            } else {
                XCTAssertNil(extractedValue)
            }
        }
    }

    func test_storageServiceSuccessfullyStoreCollectionThenCleanStorageAndShouldBeNil() {
        let ex = expectation(description: "test_storageServiceSuccessfullyStoreCollectionThenCleanStorageAndShouldBeNil")
        let key = "key"
        let storable = CodableValueClass(id: 123, firstName: "firstName", lastName: "lastName")
        let storedValue = [storable]
        var extractedValue: [Codable]?
        let error: StorageError? = nil
        
        objectStorageService.storeCollection(storedValue, forKey: key, onSuccess: {
            self.objectStorageService.cleanStorage(onSuccess: {
                self.objectStorageService.getCollection(forKey: key, onSuccess: { (value: [CodableValueClass]?) in
                    extractedValue = value
                    ex.fulfill()
                })
            })
        })
        
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
        let error: StorageError? = nil
        
        objectStorageService.storeObject(storedValue, forKey: key, onSuccess: {
            self.objectStorageService.getObject(forKey: key, onSuccess: { (value: CodableValueClass?) in
                extractedValue = value
                ex.fulfill()
            })
        })
        
        waitForExpectations(timeout: defaultTimeout) { (_) in
            if error != nil {
                XCTFail()
            } else {
                XCTAssertNotNil(extractedValue)
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
        let error: StorageError? = nil
        
        objectStorageService.getObject(forKey: key, onSuccess: { (value: CodableValueClass?) in
            extractedValue = value
            ex.fulfill()
        })
        
        waitForExpectations(timeout: defaultTimeout) { (_) in
            if error != nil {
                XCTFail()
            } else {
                XCTAssertNil(extractedValue)
            }
        }
    }
    
}
