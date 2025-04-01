//
//  DefaultStorage.swift
//  GKStorageKit
//
//  Created by Gligor Kotushevski on 20/03/17.
//  Copyright © 2017 Gligor Kotushevski. All rights reserved.
//

import Foundation
import Valet

public final class DefaultStorage: StorageProtocol {

    public init() {}

    public var storageIdentifier: String {
        return "defaultStorage"
    }
    
    public var persistentStorageIdentifier: String {
        return "persistentStorage"
    }

    public var secureStorage: SecureStorage {
        guard let valetIdentifier = Identifier(nonEmpty: storageIdentifier) else {
            fatalError("Could not set up secure storage")
        }
        return Valet.valet(with: valetIdentifier, accessibility: .whenUnlocked)
    }
    
    public var secureEnclaveStorage: SecureEnclaveStorage {
        guard let valetIdentifier = Identifier(nonEmpty: storageIdentifier) else {
            fatalError("Could not set up secure enclave storage")
        }
        return SecureEnclaveValet.valet(with: valetIdentifier, accessControl: .biometricCurrentSet)
    }

    public var userDefaults: UserDefaults {
        return UserDefaults(suiteName: storageIdentifier)!
    }
    
    public var persistentUserDefaults: UserDefaults {
        return UserDefaults(suiteName: persistentStorageIdentifier)!
    }

    public var fileStorageUrl: URL {
        // documents storage is the default fileStorageUrl
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }

}
