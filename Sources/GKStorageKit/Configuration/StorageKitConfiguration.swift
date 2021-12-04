//
//  StorageKitConfiguration.swift
//  GKStorageKit
//
//  Created by Gligor Kotushevski on 20/03/17.
//  Copyright © 2017 Gligor Kotushevski. All rights reserved.
//

final class StorageKitConfiguration {

    private static let instance = StorageKitConfiguration()

    class var shared: StorageKitConfigurationProtocol {
        return StorageKitConfiguration.instance.configuration
    }

    private init() {}

    private var config: StorageKitConfigurationProtocol?

    private var configuration: StorageKitConfigurationProtocol {
        if let config = config {
            return config
        } else {
            preconditionFailure("GKStorageKit configuration must be setup before use")
        }
    }

    class func setup(with config: StorageKitConfigurationProtocol) {
        StorageKitConfiguration.instance.config = config
    }

    class func tearDownConfig() {
        StorageKitConfiguration.instance.config = nil
    }

}
