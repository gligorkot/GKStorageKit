//
//  EnvironmentConfiguration.swift
//  GKStorageKit
//
//  Created by Gligor Kotushevski on 20/03/17.
//  Copyright © 2017 Gligor Kotushevski. All rights reserved.
//

final class EnvironmentConfiguration: StorageKitConfigurationProtocol {

    private let _storage: StorageProtocol

    init(storage: StorageProtocol) {
        self._storage = storage
    }

    var storage: StorageProtocol {
        return _storage
    }
}
