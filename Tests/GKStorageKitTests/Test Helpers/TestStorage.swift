//
//  TestEnvironmentConfiguration.swift
//  GKStorageKitTests
//
//  Created by Gligor Kotushevski on 20/03/17.
//  Copyright © 2017 Gligor Kotushevski. All rights reserved.
//

import Foundation
import Valet
@testable import GKStorageKit

final class TestStorage: StorageProtocol {
    
    var storageIdentifier: String {
        return "testStorage"
    }

    var secureStorage: SecureStorage {
        return Valet.iCloudValet(with: Identifier(nonEmpty: storageIdentifier)!, accessibility: .whenUnlocked)
    }

    var userDefaults: UserDefaults {
        return UserDefaults(suiteName: storageIdentifier)!
    }

    var fileStorageUrl: URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
}

final class ErrorStorage: StorageProtocol {

    var storageIdentifier: String {
        return "errorTestStorage"
    }

    var secureStorage: SecureStorage {
        return ErrorValet()
    }

    var userDefaults: UserDefaults {
        return UserDefaults(suiteName: storageIdentifier)!
    }

    var fileStorageUrl: URL {
        return URL(string: "errorUrl")!
    }
    
}
