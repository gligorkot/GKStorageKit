//
//  DefaultStorage.swift
//  GKStorageKit
//
//  Created by Gligor Kotushevski on 20/03/17.
//  Copyright © 2017 Gligor Kotushevski. All rights reserved.
//

import Valet

public final class DefaultStorage: StorageProtocol {

    public init() {}

    public var storageIdentifier: String {
        return "defaultStorage"
    }

    public var secureStorage: SecureStorage {
        return Valet.valet(with: Identifier(nonEmpty: storageIdentifier)!, accessibility: .whenUnlocked)
    }

    public var userDefaults: UserDefaults {
        return UserDefaults(suiteName: storageIdentifier)!
    }

    public var fileStorageUrl: URL {
        // documents storage is the default fileStorageUrl
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }

}
