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
    
    var persistentStorageIdentifier: String {
        return "testPersistentStorage"
    }

    var secureStorage: SecureStorage {
        return Valet.iCloudValet(with: Identifier(nonEmpty: storageIdentifier)!, accessibility: .whenUnlocked)
    }
    
    var secureEnclaveStorage: SecureEnclaveStorage {
        return SecureEnclaveValet.valet(with: Identifier(nonEmpty: storageIdentifier)!, accessControl: .biometricCurrentSet)
    }

    var userDefaults: UserDefaults {
        return UserDefaults(suiteName: storageIdentifier)!
    }
    
    var persistentUserDefaults: UserDefaults {
        return UserDefaults(suiteName: persistentStorageIdentifier)!
    }

    var fileStorageUrl: URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
}

final class ErrorStorage: StorageProtocol {

    var storageIdentifier: String {
        return "errorTestStorage"
    }
    
    var persistentStorageIdentifier: String {
        return "errorTestPersistentStorage"
    }

    var secureStorage: SecureStorage {
        return ErrorValet()
    }
    
    var secureEnclaveStorage: SecureEnclaveStorage {
        return ErrorValetSecureEnclave()
    }

    var userDefaults: UserDefaults {
        return UserDefaults(suiteName: storageIdentifier)!
    }
    
    var persistentUserDefaults: UserDefaults {
        return UserDefaults(suiteName: persistentStorageIdentifier)!
    }

    var fileStorageUrl: URL {
        return URL(string: "errorUrl")!
    }
    
}
