//
//  FileStorageServiceTests.swift
//  GKStorageKitTests
//
//  Created by Gligor Kotushevski on 20/03/17.
//  Copyright © 2017 Gligor Kotushevski. All rights reserved.
//

import XCTest
@testable import GKStorageKit
@testable import GKBaseKit

class FileStorageServiceTests: XCTestCase, StorageKitDecorator {

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

    func test_storageServiceSuccessfullyStoreFile() {
        let ex = expectation(description: "test_storageServiceSuccessfullyStoreFile")
        let storedValue = Data()
        var extractedValue: Data?
        var error: ErrorResponse?

        FileStorageService(documentsUrl: storage.fileStorageUrl).storeFile(storedValue, fileExtension: "mp3", onSuccess: { destinationUrl in
            extractedValue = try? Data(contentsOf: destinationUrl)
            ex.fulfill()
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

    func test_storageServiceErrorStoreFile() {
        StorageKit.initStorageKit(storage: ErrorStorage())

        let ex = expectation(description: "test_storageServiceErrorStoreFile")
        let storedValue = Data()
        var error: ErrorResponse?

        FileStorageService(documentsUrl: storage.fileStorageUrl).storeFile(storedValue, fileExtension: "mp3", onSuccess: { _ in
            ex.fulfill()
        }) { e in
            error = e
            ex.fulfill()
        }

        waitForExpectations(timeout: defaultTimeout) { (_) in
            if let error = error {
                XCTAssertEqual(error.title, "Storage")
                XCTAssertEqual(error.message, "Unable to save file to documents directory.")
            } else {
                XCTFail()
            }
        }
    }

    func test_storageServiceSuccessfullyCleanFileStorage() {
        let ex = expectation(description: "test_storageServiceSuccessfullyCleanFileStorage")
        var error: ErrorResponse?

        FileStorageService(documentsUrl: storage.fileStorageUrl).cleanStorage(onSuccess: {
            ex.fulfill()
        }) { e in
            error = e
            ex.fulfill()
        }

        waitForExpectations(timeout: defaultTimeout) { (_) in
            if error != nil {
                XCTFail()
            }
        }
    }

    func test_storageServiceErrorCleanFileStorage() {
        StorageKit.initStorageKit(storage: ErrorStorage())

        let ex = expectation(description: "test_storageServiceErrorCleanFileStorage")
        var error: ErrorResponse?

        FileStorageService(documentsUrl: storage.fileStorageUrl).cleanStorage(onSuccess: {
            ex.fulfill()
        }) { e in
            error = e
            ex.fulfill()
        }

        waitForExpectations(timeout: defaultTimeout) { (_) in
            if let error = error {
                XCTAssertEqual(error.title, "Storage")
                XCTAssertEqual(error.message, "Unable to clean file storage.")
            } else {
                XCTFail()
            }
        }
    }
}
