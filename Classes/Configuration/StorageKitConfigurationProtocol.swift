//
//  StorageKitConfigurationProtocol.swift
//  GKStorageKit
//
//  Created by Gligor Kotushevski on 20/03/17.
//  Copyright © 2017 Gligor Kotushevski. All rights reserved.
//

protocol StorageKitConfigurationProtocol {
    var storage: StorageProtocol { get }
}

/// every time a new interface is added above, it needs to be returned in the default implementation below
protocol StorageKitDecorator: StorageKitConfigurationProtocol {}
extension StorageKitDecorator {
    var storage: StorageProtocol {
        return StorageKitConfiguration.shared.storage
    }
}
