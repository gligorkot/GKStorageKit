//
//  StorageKitConfigurationTests.swift
//  GKStorageKitTests
//
//  Created by Gligor Kotushevski on 20/03/17.
//  Copyright © 2017 Gligor Kotushevski. All rights reserved.
//

import XCTest
import Nimble
@testable import GKStorageKit

class StorageKitConfigurationTests: XCTestCase {

    override func tearDown() {
        StorageKitConfiguration.tearDownConfig()
    }

    func test_configurationFatalErrorIfNotSetup() {
        expect { _ = StorageKitConfiguration.shared }.to(throwAssertion())
    }

}
